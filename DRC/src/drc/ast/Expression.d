module drc.ast.Expression;
/+
import drc.ast.Node;
import drc.semantic.Types,
       drc.semantic.Symbol;
import common;

/// Корневой классс всех выражений.
abstract class Выражение : Узел
{
  Тип тип; /// Семантический тип данного выражения.
  Символ символ;

  this()
  {
    super(КатегорияУзла.Выражение);
  }

  /// Возвращает да, если член 'тип' не равен пусто.
  бул естьТип()
  {
    return тип !is пусто;
  }

  /// Возвращает да, если член 'символ' не равен пусто.
  бул естьСимвол()
  {
    return символ !is пусто;
  }

  override abstract Выражение копируй();
}
+/

import cidrus;

import dmd.aggregate;
import dmd.aliasthis;
import dmd.apply;
import dmd.arrayop;
import dmd.arraytypes;
import  drc.ast.Node;
import dmd.gluelayer;
import dmd.canthrow;
import dmd.complex;
import dmd.constfold;
import dmd.ctfeexpr;
import dmd.ctorflow;
import dmd.dcast;
import dmd.dclass;
import dmd.declaration;
import dmd.delegatize;
import dmd.dimport;
import dmd.dinterpret;
import dmd.dmodule;
import dmd.dscope;
import dmd.dstruct;
import dmd.дсимвол;
import dmd.dsymbolsem;
import dmd.dtemplate;
import dmd.errors;
import dmd.escape;
import dmd.expressionsem;
import dmd.func;
import dmd.globals;
import dmd.hdrgen;
import drc.lexer.Id;
import drc.lexer.Identifier;
import dmd.inline;
import dmd.mtype;
import dmd.nspace;
import dmd.objc;
import dmd.opover;
import dmd.optimize;
import util.ctfloat;
import util.filename;
import util.outbuffer;
import util.rmem;
import drc.ast.Node;
import util.string;
import dmd.safe;
import dmd.sideeffect;
import dmd.target;
import drc.lexer.Tokens;
import dmd.typesem;
import util.utf;
import drc.ast.Visitor;
import drc.semantic.Types,
       drc.semantic.Symbol;

const LOGSEMANTIC = нет;
проц emplaceExp(T : Выражение, Args...)(ук p, Args args)
{
    scope tmp = new T(args);
    cidrus.memcpy(p, cast(ук)tmp, __traits(classInstanceSize, T));
}

проц emplaceExp(T : UnionExp)(T* p, Выражение e)
{
    memcpy(p, cast(ук)e, e.size);
}

// Возвращает значение для `checkModifiable`
enum Modifiable
{
    /// Не модифицируемый
    no,
    /// Модифицируемый (этот тип мутабелен)
    yes,
    /// Модифицируем, та как это инициализация
    initialization,
}

/****************************************
* Найти первое беззапятое Выражение.
* Параметры:
*      e = Выражения, соединённые запятыми
* Возвращает:
*      самое левое беззапятое Выражение
*/
Выражение firstComma(inout Выражение e)
{
    Выражение ex = /*cast()*/e;
    while (ex.op == ТОК2.comma)
        ex = (cast(CommaExp)ex).e1;
    return ex;

}

/****************************************
* Находит последнее беззапятое Выражение.
* Параметры:
*      e = Выражения, соединенные запятыми
* Возвращает:
*      самое правое беззапятое Выражение
*/

Выражение lastComma(inout Выражение e)
{
    Выражение ex = /*cast()*/e;
    while (ex.op == ТОК2.comma)
        ex = (cast(CommaExp)ex).e2;
    return ex;

}

/*****************************************
* Определить, доступно ли `this` проходкой вверх включающих
* мастабов до нахождения функции.
*
* Параметры:
*      sc = откуда начинать поиск включающей функции
* Возвращает:
*      Найденную функцию, если она удовлетворяет `isThis()`, иначе `null`
*/
FuncDeclaration hasThis(Scope* sc)
{
    //printf("hasThis()\n");
    ДСимвол p = sc.родитель;
    while (p && p.isTemplateMixin())
        p = p.родитель;
    FuncDeclaration fdthis = p ? p.isFuncDeclaration() : null;
    //printf("fdthis = %p, '%s'\n", fdthis, fdthis ? fdthis.вТкст0() : "");

    // Go upwards until we найди the enclosing member function
    FuncDeclaration fd = fdthis;
    while (1)
    {
        if (!fd)
        {
            return null;
        }
        if (!fd.isNested() || fd.isThis() || (fd.isThis2 && fd.isMember2()))
            break;

        ДСимвол родитель = fd.родитель;
        while (1)
        {
            if (!родитель)
                return null;
            TemplateInstance ti = родитель.isTemplateInstance();
            if (ti)
                родитель = ti.родитель;
            else
                break;
        }
        fd = родитель.isFuncDeclaration();
    }

    if (!fd.isThis() && !(fd.isThis2 && fd.isMember2()))
    {
        return null;
    }

    assert(fd.vthis);
    return fd;

}

/***********************************
* Determine if a `this` is needed to access `d`.
* Параметры:
*      sc = context
*      d = declaration to check
* Возвращает:
*      да means a `this` is needed
*/
бул isNeedThisScope(Scope* sc, Declaration d)
{
    if (sc.intypeof == 1)
        return нет;

    AggregateDeclaration ad = d.isThis();
    if (!ad)
        return нет;
    //printf("d = %s, ad = %s\n", d.вТкст0(), ad.вТкст0());

    for (ДСимвол s = sc.родитель; s; s = s.toParentLocal())
    {
        //printf("\ts = %s %s, toParent2() = %p\n", s.вид(), s.вТкст0(), s.toParent2());
        if (AggregateDeclaration ad2 = s.isAggregateDeclaration())
        {
            if (ad2 == ad)
                return нет;
            else if (ad2.isNested())
                continue;
            else
                return да;
        }
        if (FuncDeclaration f = s.isFuncDeclaration())
        {
            if (f.isMemberLocal())
                break;
        }
    }
    return да;
}

/******************************
* check e is exp.opDispatch!(tiargs) or not
* It's используется to switch to UFCS the semantic analysis path
*/
бул isDotOpDispatch(Выражение e)
{
    if (auto dtie = e.isDotTemplateInstanceExp())
        return dtie.ti.имя == Id.opDispatch;
    return нет;
}

/****************************************
* Expand tuples.
* Input:
*      exps    aray of Выражения
* Output:
*      exps    rewritten in place
*/
проц expandTuples(Выражения* exps)
{
    //printf("expandTuples()\n");
    if (exps is null)
        return;

    for (т_мера i = 0; i < exps.dim; i++)
    {
        Выражение arg = (*exps)[i];
        if (!arg)
            continue;

        // Look for кортеж with 0 члены
        if (auto e = arg.isTypeExp())
        {
            if (auto tt = e.тип.toBasetype().isTypeTuple())
            {
                if (!tt.arguments || tt.arguments.dim == 0)
                {
                    exps.удали(i);
                    if (i == exps.dim)
                        return;
                    i--;
                    continue;
                }
            }
        }

        // Inline expand all the tuples
        while (arg.op == ТОК2.кортеж)
        {
            TupleExp te = cast(TupleExp)arg;
            exps.удали(i); // удали arg
            exps.вставь(i, te.exps); // replace with кортеж contents
            if (i == exps.dim)
                return; // empty кортеж, no more arguments
            (*exps)[i] = Выражение.combine(te.e0, (*exps)[i]);
            arg = (*exps)[i];
        }
    }
}

/****************************************
* Expand alias this tuples.
*/
TupleDeclaration isAliasThisTuple(Выражение e)
{
    if (!e.тип)
        return null;

    Тип t = e.тип.toBasetype();
    while (да)
    {
        if (ДСимвол s = t.toDsymbol(null))
        {
            if (auto ad = s.isAggregateDeclaration())
            {
                s = ad.aliasthis ? ad.aliasthis.sym : null;
                if (s && s.isVarDeclaration())
                {
                    TupleDeclaration td = s.isVarDeclaration().toAlias().isTupleDeclaration();
                    if (td && td.isexp)
                        return td;
                }
                if (Тип att = t.aliasthisOf())
                {
                    t = att;
                    continue;
                }
            }
        }
        return null;
    }
}

цел expandAliasThisTuples(Выражения* exps, т_мера starti = 0)
{
    if (!exps || exps.dim == 0)
        return -1;

    for (т_мера u = starti; u < exps.dim; u++)
    {
        Выражение exp = (*exps)[u];
        if (TupleDeclaration td = exp.isAliasThisTuple)
        {
            exps.удали(u);
            foreach (i, o; *td.objects)
            {
                auto d = o.выражение_ли().isDsymbolExp().s.isDeclaration();
                auto e = new DotVarExp(exp.место, exp, d);
                assert(d.тип);
                e.тип = d.тип;
                exps.вставь(u + i, e);
            }
            version (none)
            {
                printf("expansion ->\n");
                foreach (e; exps)
                {
                    printf("\texps[%d] e = %s %s\n", i, Сема2.tochars[e.op], e.вТкст0());
                }
            }
            return cast(цел)u;
        }
    }
    return -1;
}

/****************************************
* If `s` is a function template, i.e. the only member of a template
* and that member is a function, return that template.
* Параметры:
*      s = symbol that might be a function template
* Возвращает:
*      template for that function, otherwise null
*/
TemplateDeclaration getFuncTemplateDecl(ДСимвол s)
{
    FuncDeclaration f = s.isFuncDeclaration();
    if (f && f.родитель)
    {
        if (auto ti = f.родитель.isTemplateInstance())
        {
            if (!ti.isTemplateMixin() && ti.tempdecl)
            {
                auto td = ti.tempdecl.isTemplateDeclaration();
                if (td.onemember && td.идент == f.идент)
                {
                    return td;
                }
            }
        }
    }
    return null;
}

/************************************************
* If we want the значение of this Выражение, but do not want to call
* the destructor on it.
*/
Выражение valueNoDtor(Выражение e)
{
    auto ex = lastComma(e);

    if (auto ce = ex.isCallExp())
    {
        /* The struct значение returned from the function is transferred
		* so do not call the destructor on it.
		* Recognize:
		*       ((S _ctmp = S.init), _ctmp).this(...)
		* and make sure the destructor is not called on _ctmp
		* BUG: if ex is a CommaExp, we should go down the right side.
		*/
        if (auto dve = ce.e1.isDotVarExp())
        {
            if (dve.var.isCtorDeclaration())
            {
                // It's a constructor call
                if (auto comma = dve.e1.isCommaExp())
                {
                    if (auto ve = comma.e2.isVarExp())
                    {
                        VarDeclaration ctmp = ve.var.isVarDeclaration();
                        if (ctmp)
                        {
                            ctmp.класс_хранения |= STC.nodtor;
                            assert(!ce.isLvalue());
                        }
                    }
                }
            }
        }
    }
    else if (auto ve = ex.isVarExp())
    {
        auto vtmp = ve.var.isVarDeclaration();
        if (vtmp && (vtmp.класс_хранения & STC.rvalue))
        {
            vtmp.класс_хранения |= STC.nodtor;
        }
    }
    return e;
}

/*********************************************
* If e is an instance of a struct, and that struct has a копируй constructor,
* rewrite e as:
*    (tmp = e),tmp
* Input:
*      sc = just используется to specify the scope of created temporary variable
*      destinationType = the тип of the объект on which the копируй constructor is called;
*                        may be null if the struct defines a postblit
*/
private Выражение callCpCtor(Scope* sc, Выражение e, Тип destinationType)
{
    if (auto ts = e.тип.baseElemOf().isTypeStruct())
    {
        StructDeclaration sd = ts.sym;
        if (sd.postblit || sd.hasCopyCtor)
        {
            /* Create a variable tmp, and replace the argument e with:
			*      (tmp = e),tmp
			* and let AssignExp() handle the construction.
			* This is not the most efficient, ideally tmp would be constructed
			* directly onto the stack.
			*/
            auto tmp = copyToTemp(STC.rvalue, "__copytmp", e);
            if (sd.hasCopyCtor && destinationType)
                tmp.тип = destinationType;
            tmp.класс_хранения |= STC.nodtor;
            tmp.dsymbolSemantic(sc);
            Выражение de = new DeclarationExp(e.место, tmp);
            Выражение ve = new VarExp(e.место, tmp);
            de.тип = Тип.tvoid;
            ve.тип = e.тип;
            return Выражение.combine(de, ve);
        }
    }
    return e;
}

/************************************************
* Handle the postblit call on lvalue, or the move of rvalue.
*
* Параметры:
*   sc = the scope where the Выражение is encountered
*   e = the Выражение the needs to be moved or copied (source)
*   t = if the struct defines a копируй constructor, the тип of the destination
*
* Возвращает:
*  The Выражение that копируй constructs or moves the значение.
*/
extern (D) Выражение doCopyOrMove(Scope *sc, Выражение e, Тип t = null)
{
    if (auto ce = e.isCondExp())
    {
        ce.e1 = doCopyOrMove(sc, ce.e1);
        ce.e2 = doCopyOrMove(sc, ce.e2);
    }
    else
    {
        e = e.isLvalue() ? callCpCtor(sc, e, t) : valueNoDtor(e);
    }
    return e;
}

/****************************************************************/
/* A тип meant as a union of all the Выражение types,
* to serve essentially as a Variant that will sit on the stack
* during CTFE to reduce memory consumption.
*/
struct UnionExp
{
    // yes, default constructor does nothing
    this(Выражение e)
    {
        memcpy(&this, cast(ук)e, e.size);
    }

    /* Extract pointer to Выражение
	*/
	Выражение exp()
    {
        return cast(Выражение)&u;
    }

    /* Convert to an allocated Выражение
	*/
	Выражение копируй()
    {
        Выражение e = exp();
        //if (e.size > sizeof(u)) printf("%s\n", Сема2::вТкст0(e.op));
        assert(e.size <= u.sizeof);
        switch (e.op)
        {
            case ТОК2.cantВыражение:    return CTFEExp.cantexp;
            case ТОК2.voidВыражение:    return CTFEExp.voidexp;
            case ТОК2.break_:            return CTFEExp.breakexp;
            case ТОК2.continue_:         return CTFEExp.continueexp;
            case ТОК2.goto_:             return CTFEExp.gotoexp;
            default:                    return e.копируй();
        }
    }

private:
    // Гарант that the union is suitably aligned.
    align(8) union __AnonStruct__u
    {
        сим[__traits(classInstanceSize, Выражение)] exp;
        сим[__traits(classInstanceSize, IntegerExp)] integerexp;
        сим[__traits(classInstanceSize, ErrorExp)] errorexp;
        сим[__traits(classInstanceSize, RealExp)] realexp;
        сим[__traits(classInstanceSize, ComplexExp)] complexexp;
        сим[__traits(classInstanceSize, SymOffExp)] symoffexp;
        сим[__traits(classInstanceSize, StringExp)] stringexp;
        сим[__traits(classInstanceSize, ArrayLiteralExp)] arrayliteralexp;
        сим[__traits(classInstanceSize, AssocArrayLiteralExp)] assocarrayliteralexp;
        сим[__traits(classInstanceSize, StructLiteralExp)] structliteralexp;
        сим[__traits(classInstanceSize, NullExp)] nullexp;
        сим[__traits(classInstanceSize, DotVarExp)] dotvarexp;
        сим[__traits(classInstanceSize, AddrExp)] addrexp;
        сим[__traits(classInstanceSize, IndexExp)] indexexp;
        сим[__traits(classInstanceSize, SliceExp)] sliceexp;
        сим[__traits(classInstanceSize, VectorExp)] vectorexp;
    }

    __AnonStruct__u u;
}

/********************************
* Test to see if two reals are the same.
* Regard NaN's as equivalent.
* Regard +0 and -0 as different.
* Параметры:
*      x1 = first operand
*      x2 = second operand
* Возвращает:
*      да if x1 is x2
*      else нет
*/
бул RealIdentical(real_t x1, real_t x2)
{
    return (CTFloat.isNaN(x1) && CTFloat.isNaN(x2)) || CTFloat.isIdentical(x1, x2);
}

/************************ TypeDotIdExp ************************************/
/* Things like:
*      цел.size
*      foo.size
*      (foo).size
*      cast(foo).size
*/
DotIdExp typeDotIdExp(ref Место место, Тип тип, Идентификатор2 идент)
{
    return new DotIdExp(место, new TypeExp(место, тип), идент);
}

/***************************************************
* Given an Выражение, найди the variable it really is.
*
* For example, `a[index]` is really `a`, and `s.f` is really `s`.
* Параметры:
*      e = Выражение to look at
* Возвращает:
*      variable if there is one, null if not
*/
VarDeclaration expToVariable(Выражение e)
{
    while (1)
    {
        switch (e.op)
        {
            case ТОК2.variable:
                return (cast(VarExp)e).var.isVarDeclaration();

            case ТОК2.dotVariable:
                e = (cast(DotVarExp)e).e1;
                continue;

            case ТОК2.index:
				{
					IndexExp ei = cast(IndexExp)e;
					e = ei.e1;
					Тип ti = e.тип.toBasetype();
					if (ti.ty == Tsarray)
						continue;
					return null;
				}

            case ТОК2.slice:
				{
					SliceExp ei = cast(SliceExp)e;
					e = ei.e1;
					Тип ti = e.тип.toBasetype();
					if (ti.ty == Tsarray)
						continue;
					return null;
				}

            case ТОК2.this_:
            case ТОК2.super_:
                return (cast(ThisExp)e).var.isVarDeclaration();

            default:
                return null;
        }
    }
}

enum OwnedBy : ббайт
{
    code,          // normal code Выражение in AST
    ctfe,          // значение Выражение for CTFE
    cache,         // constant значение cached for CTFE
}

const WANTvalue  = 0;    // default
const WANTexpand = 1;    // expand const/const variables if possible

/***********************************************************
* http://dlang.org/spec/Выражение.html#Выражение
*/
abstract class Выражение : УзелАСД
{
    const ТОК2 op;   // для уменьшения использования dynamic_cast
    ббайт size;     // # байтов в Выражение, чтобы можно было копируй() его
    ббайт parens;   // если это parenthesized Выражение
    Тип тип;      // !=null означает, что semantic() была запущена
    Место место;      // положение файла	
///////////////
//ДЛЯ СОВМЕСТИМОСТИ С ДИЛ
	Символ символ;

  this()
  {
    super(КатегорияУзла.Выражение);
  }

  /// Возвращает да, если член 'тип' не равен пусто.
  бул естьТип()
  {
    return тип !is пусто;
  }

  /// Возвращает да, если член 'символ' не равен пусто.
  бул естьСимвол()
  {
    return символ !is пусто;
  }

  //override abstract Выражение копируй();
  
  //////////////////////////////////////

    this(ref Место место, ТОК2 op, цел size)
    {
        //printf("Выражение::Выражение(op = %d) this = %p\n", op, this);
        this.место = место;
        this.op = op;
        this.size = cast(ббайт)size;
    }

    static проц _иниц()
    {
        CTFEExp.cantexp = new CTFEExp(ТОК2.cantВыражение);
        CTFEExp.voidexp = new CTFEExp(ТОК2.voidВыражение);
        CTFEExp.breakexp = new CTFEExp(ТОК2.break_);
        CTFEExp.continueexp = new CTFEExp(ТОК2.continue_);
        CTFEExp.gotoexp = new CTFEExp(ТОК2.goto_);
        CTFEExp.showcontext = new CTFEExp(ТОК2.showCtfeContext);
    }

    /**
	* Deinitializes the глоб2 state of the compiler.
	*
	* This can be используется to restore the state set by `_иниц` to its original
	* state.
	*/
    static проц deinitialize()
    {
        CTFEExp.cantexp = CTFEExp.cantexp.init;
        CTFEExp.voidexp = CTFEExp.voidexp.init;
        CTFEExp.breakexp = CTFEExp.breakexp.init;
        CTFEExp.continueexp = CTFEExp.continueexp.init;
        CTFEExp.gotoexp = CTFEExp.gotoexp.init;
        CTFEExp.showcontext = CTFEExp.showcontext.init;
    }

    /*********************************
	* Does *not* do a deep копируй.
	*/
    final Выражение копируй()
    {
        Выражение e;
        if (!size)
        {
            debug
            {
                fprintf(stderr, "No Выражение копируй for: %s\n", вТкст0());
                printf("op = %d\n", op);
            }
            assert(0);
        }
        e = cast(Выражение)mem.xmalloc(size);
        //printf("Выражение::копируй(op = %d) e = %p\n", op, e);
        return cast(Выражение)memcpy(cast(ук)e, cast(ук)this, size);
    }

    Выражение syntaxCopy()
    {
        //printf("Выражение::syntaxCopy()\n");
        //print();
        return копируй();
    }

    // kludge for template.выражение_ли()
    override final ДИНКАСТ динкаст()
    {
        return ДИНКАСТ.Выражение;
    }

    override ткст0 вТкст0()
    {
        БуфВыв буф;
        HdrGenState hgs;
        toCBuffer(this, &буф, &hgs);
        return буф.extractChars();
    }

    final проц выведиОшибку(ткст0 format, ...)
    {
        if (тип != Тип.terror)
        {
            va_list ap;
            va_start(ap, format);
            .verror(место, format, ap);
            va_end(ap);
        }
    }

    final проц errorSupplemental(ткст0 format, ...)
    {
        if (тип == Тип.terror)
            return;

        va_list ap;
        va_start(ap, format);
        .verrorSupplemental(место, format, ap);
        va_end(ap);
    }

    final проц warning(ткст0 format, ...)
    {
        if (тип != Тип.terror)
        {
            va_list ap;
            va_start(ap, format);
            .vwarning(место, format, ap);
            va_end(ap);
        }
    }

    final проц deprecation(ткст0 format, ...)
    {
        if (тип != Тип.terror)
        {
            va_list ap;
            va_start(ap, format);
            .vdeprecation(место, format, ap);
            va_end(ap);
        }
    }

    /**********************************
	* Combine e1 and e2 by CommaExp if both are not NULL.
	*/
    extern (D) static Выражение combine(Выражение e1, Выражение e2)
    {
        if (e1)
        {
            if (e2)
            {
                e1 = new CommaExp(e1.место, e1, e2);
                e1.тип = e2.тип;
            }
        }
        else
            e1 = e2;
        return e1;
    }

    extern (D) static Выражение combine(Выражение e1, Выражение e2, Выражение e3)
    {
        return combine(combine(e1, e2), e3);
    }

    extern (D) static Выражение combine(Выражение e1, Выражение e2, Выражение e3, Выражение e4)
    {
        return combine(combine(e1, e2), combine(e3, e4));
    }

    /**********************************
	* If 'e' is a tree of commas, returns the rightmost Выражение
	* by stripping off it from the tree. The remained part of the tree
	* is returned via e0.
	* Otherwise 'e' is directly returned and e0 is set to NULL.
	*/
    extern (D) static Выражение extractLast(Выражение e, out Выражение e0)
    {
        if (e.op != ТОК2.comma)
        {
            return e;
        }

        CommaExp ce = cast(CommaExp)e;
        if (ce.e2.op != ТОК2.comma)
        {
            e0 = ce.e1;
            return ce.e2;
        }
        else
        {
            e0 = e;

            Выражение* pce = &ce.e2;
            while ((cast(CommaExp)(*pce)).e2.op == ТОК2.comma)
            {
                pce = &(cast(CommaExp)(*pce)).e2;
            }
            assert((*pce).op == ТОК2.comma);
            ce = cast(CommaExp)(*pce);
            *pce = ce.e1;

            return ce.e2;
        }
    }

    extern (D) static Выражения* arraySyntaxCopy(Выражения* exps)
    {
        Выражения* a = null;
        if (exps)
        {
            a = new Выражения(exps.dim);
            foreach (i, e; *exps)
            {
                (*a)[i] = e ? e.syntaxCopy() : null;
            }
        }
        return a;
    }

    dinteger_t toInteger()
    {
        //printf("Выражение %s\n", Сема2::вТкст0(op));
        выведиОшибку("integer constant Выражение expected instead of `%s`", вТкст0());
        return 0;
    }

    uinteger_t toUInteger()
    {
        //printf("Выражение %s\n", Сема2::вТкст0(op));
        return cast(uinteger_t)toInteger();
    }

    real_t toReal()
    {
        выведиОшибку("floating point constant Выражение expected instead of `%s`", вТкст0());
        return CTFloat.нуль;
    }

    real_t toImaginary()
    {
        выведиОшибку("floating point constant Выражение expected instead of `%s`", вТкст0());
        return CTFloat.нуль;
    }

    complex_t toComplex()
    {
        выведиОшибку("floating point constant Выражение expected instead of `%s`", вТкст0());
        return complex_t(CTFloat.нуль);
    }

    StringExp вТкстExp()
    {
        return null;
    }

    TupleExp toTupleExp()
    {
        return null;
    }

    /***************************************
	* Return !=0 if Выражение is an lvalue.
	*/
    бул isLvalue()
    {
        return нет;
    }

    /*******************************
	* Give error if we're not an lvalue.
	* If we can, convert Выражение to be an lvalue.
	*/
    Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (!e)
            e = this;
        else if (!место.isValid())
            место = e.место;

        if (e.op == ТОК2.тип)
            выведиОшибку("`%s` is a `%s` definition and cannot be modified", e.тип.вТкст0(), e.тип.вид());
        else
            выведиОшибку("`%s` is not an lvalue and cannot be modified", e.вТкст0());

        return new ErrorExp();
    }

    Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        //printf("Выражение::modifiableLvalue() %s, тип = %s\n", вТкст0(), тип.вТкст0());
        // See if this Выражение is a modifiable lvalue (i.e. not const)
        if (checkModifiable(sc) == Modifiable.yes)
        {
            assert(тип);
            if (!тип.isMutable())
            {
                if (auto dve = this.isDotVarExp())
                {
                    if (isNeedThisScope(sc, dve.var))
                        for (ДСимвол s = sc.func; s; s = s.toParentLocal())
						{
							FuncDeclaration ff = s.isFuncDeclaration();
							if (!ff)
								break;
							if (!ff.тип.isMutable)
							{
								выведиОшибку("cannot modify `%s` in `%s` function", вТкст0(), MODtoChars(тип.mod));
								return new ErrorExp();
							}
						}
                }
                выведиОшибку("cannot modify `%s` Выражение `%s`", MODtoChars(тип.mod), вТкст0());
                return new ErrorExp();
            }
            else if (!тип.isAssignable())
            {
                выведиОшибку("cannot modify struct instance `%s` of тип `%s` because it содержит `const` or `const` члены",
							 вТкст0(), тип.вТкст0());
                return new ErrorExp();
            }
        }
        return toLvalue(sc, e);
    }

    final Выражение implicitCastTo(Scope* sc, Тип t)
    {
        return .implicitCastTo(this, sc, t);
    }

    final MATCH implicitConvTo(Тип t)
    {
        return .implicitConvTo(this, t);
    }

    final Выражение castTo(Scope* sc, Тип t)
    {
        return .castTo(this, sc, t);
    }

    /****************************************
	* Resolve __FILE__, __LINE__, __MODULE__, __FUNCTION__, __PRETTY_FUNCTION__, __FILE_FULL_PATH__ to место.
	*/
    Выражение resolveLoc(ref Место место, Scope* sc)
    {
        this.место = место;
        return this;
    }

    /****************************************
	* Check that the Выражение has a valid тип.
	* If not, generates an error "... has no тип".
	* Возвращает:
	*      да if the Выражение is not valid.
	* Note:
	*      When this function returns да, `checkValue()` should also return да.
	*/
    бул checkType()
    {
        return нет;
    }

    /****************************************
	* Check that the Выражение has a valid значение.
	* If not, generates an error "... has no значение".
	* Возвращает:
	*      да if the Выражение is not valid or has проц тип.
	*/
    бул checkValue()
    {
        if (тип && тип.toBasetype().ty == Tvoid)
        {
            выведиОшибку("Выражение `%s` is `проц` and has no значение", вТкст0());
            //print(); assert(0);
            if (!глоб2.gag)
                тип = Тип.terror;
            return да;
        }
        return нет;
    }

    extern (D) final бул checkScalar()
    {
        if (op == ТОК2.error)
            return да;
        if (тип.toBasetype().ty == Terror)
            return да;
        if (!тип.isscalar())
        {
            выведиОшибку("`%s` is not a scalar, it is a `%s`", вТкст0(), тип.вТкст0());
            return да;
        }
        return checkValue();
    }

    extern (D) final бул checkNoBool()
    {
        if (op == ТОК2.error)
            return да;
        if (тип.toBasetype().ty == Terror)
            return да;
        if (тип.toBasetype().ty == Tbool)
        {
            выведиОшибку("operation not allowed on `бул` `%s`", вТкст0());
            return да;
        }
        return нет;
    }

    extern (D) final бул checkIntegral()
    {
        if (op == ТОК2.error)
            return да;
        if (тип.toBasetype().ty == Terror)
            return да;
        if (!тип.isintegral())
        {
            выведиОшибку("`%s` is not of integral тип, it is a `%s`", вТкст0(), тип.вТкст0());
            return да;
        }
        return checkValue();
    }

    extern (D) final бул checkArithmetic()
    {
        if (op == ТОК2.error)
            return да;
        if (тип.toBasetype().ty == Terror)
            return да;
        if (!тип.isintegral() && !тип.isfloating())
        {
            выведиОшибку("`%s` is not of arithmetic тип, it is a `%s`", вТкст0(), тип.вТкст0());
            return да;
        }
        return checkValue();
    }

    final бул checkDeprecated(Scope* sc, ДСимвол s)
    {
        return s.checkDeprecated(место, sc);
    }

    extern (D) final бул checkDisabled(Scope* sc, ДСимвол s)
    {
        if (auto d = s.isDeclaration())
        {
            return d.checkDisabled(место, sc);
        }

        return нет;
    }

    /*********************************************
	* Calling function f.
	* Check the purity, i.e. if we're in a  function
	* we can only call other  functions.
	* Возвращает да if error occurs.
	*/
    extern (D) final бул checkPurity(Scope* sc, FuncDeclaration f)
    {
        if (!sc.func)
            return нет;
        if (sc.func == f)
            return нет;
        if (sc.intypeof == 1)
            return нет;
        if (sc.flags & (SCOPE.ctfe | SCOPE.debug_))
            return нет;

        // If the call has a  родитель, then the called func must be .
        if (!f.isPure() && checkImpure(sc))
        {
            выведиОшибку("`` %s `%s` cannot call impure %s `%s`",
						 sc.func.вид(), sc.func.toPrettyChars(), f.вид(),
						 f.toPrettyChars());
            return да;
        }
        return нет;
    }

    /*******************************************
	* Accessing variable v.
	* Check for purity and safety violations.
	* Возвращает да if error occurs.
	*/
    extern (D) final бул checkPurity(Scope* sc, VarDeclaration v)
    {
        //printf("v = %s %s\n", v.тип.вТкст0(), v.вТкст0());
        /* Look for purity and safety violations when accessing variable v
		* from current function.
		*/
        if (!sc.func)
            return нет;
        if (sc.intypeof == 1)
            return нет; // allow violations inside typeof(Выражение)
        if (sc.flags & (SCOPE.ctfe | SCOPE.debug_))
            return нет; // allow violations inside compile-time evaluated Выражения and debug conditionals
        if (v.идент == Id.ctfe)
            return нет; // magic variable never violates  and safe
        if (v.isImmutable())
            return нет; // always safe and  to access immutables...
        if (v.isConst() && !v.isRef() && (v.isDataseg() || v.isParameter()) && v.тип.implicitConvTo(v.тип.immutableOf()))
            return нет; // or const глоб2/параметр values which have no mutable indirections
        if (v.класс_хранения & STC.manifest)
            return нет; // ...or manifest constants

        if (v.тип.ty == Tstruct)
        {
            StructDeclaration sd = (cast(TypeStruct)v.тип).sym;
            if (sd.hasNoFields)
                return нет;
        }

        бул err = нет;
        if (v.isDataseg())
        {
            // https://issues.dlang.org/show_bug.cgi?ид=7533
            // Accessing implicit generated __gate is .
            if (v.идент == Id.gate)
                return нет;

            if (checkImpure(sc))
            {
                выведиОшибку("`` %s `%s` cannot access mutable static данные `%s`",
							 sc.func.вид(), sc.func.toPrettyChars(), v.вТкст0());
                err = да;
            }
        }
        else
        {
            /* Given:
			* проц f() {
			*   цел fx;
			*    проц g() {
			*     цел gx;
			*     /++/ проц h() {
			*       цел hx;
			*       /++/ проц i() { }
			*     }
			*   }
			* }
			* i() can modify hx and gx but not fx
			*/

            ДСимвол vparent = v.toParent2();
            for (ДСимвол s = sc.func; !err && s; s = s.toParentP(vparent))
            {
                if (s == vparent)
                    break;

                if (AggregateDeclaration ad = s.isAggregateDeclaration())
                {
                    if (ad.isNested())
                        continue;
                    break;
                }
                FuncDeclaration ff = s.isFuncDeclaration();
                if (!ff)
                    break;
                if (ff.isNested() || ff.isThis())
                {
                    if (ff.тип.isImmutable() ||
                        ff.тип.isShared() && !MODimplicitConv(ff.тип.mod, v.тип.mod))
                    {
                        БуфВыв ffbuf;
                        БуфВыв vbuf;
                        MODMatchToBuffer(&ffbuf, ff.тип.mod, v.тип.mod);
                        MODMatchToBuffer(&vbuf, v.тип.mod, ff.тип.mod);
                        выведиОшибку("%s%s `%s` cannot access %sdata `%s`",
									 ffbuf.peekChars(), ff.вид(), ff.toPrettyChars(), vbuf.peekChars(), v.вТкст0());
                        err = да;
                        break;
                    }
                    continue;
                }
                break;
            }
        }

        /* Do not allow safe functions to access  данные
		*/
        if (v.класс_хранения & STC.gshared)
        {
            if (sc.func.setUnsafe())
            {
                выведиОшибку("`` %s `%s` cannot access `` данные `%s`",
							 sc.func.вид(), sc.func.вТкст0(), v.вТкст0());
                err = да;
            }
        }

        return err;
    }

    /*
    Check if sc.func is impure or can be made impure.
    Возвращает да on error, i.e. if sc.func is  and cannot be made impure.
    */
    private static бул checkImpure(Scope* sc)
    {
        return sc.func && (sc.flags & SCOPE.compile
						   ? sc.func.isPureBypassingInference() >= PURE.weak
						   : sc.func.setImpure());
    }

    /*********************************************
	* Calling function f.
	* Check the safety, i.e. if we're in a  function
	* we can only call  or functions.
	* Возвращает да if error occurs.
	*/
    extern (D) final бул checkSafety(Scope* sc, FuncDeclaration f)
    {
        if (!sc.func)
            return нет;
        if (sc.func == f)
            return нет;
        if (sc.intypeof == 1)
            return нет;
        if (sc.flags & (SCOPE.ctfe | SCOPE.debug_))
            return нет;

        if (!f.isSafe() && !f.isTrusted())
        {
            if (sc.flags & SCOPE.compile ? sc.func.isSafeBypassingInference() : sc.func.setUnsafe())
            {
                if (!место.isValid()) // e.g. implicitly generated dtor
                    место = sc.func.место;

                const prettyChars = f.toPrettyChars();
                выведиОшибку("`` %s `%s` cannot call `@system` %s `%s`",
							 sc.func.вид(), sc.func.toPrettyChars(), f.вид(),
							 prettyChars);
                .errorSupplemental(f.место, "`%s` is declared here", prettyChars);
                return да;
            }
        }
        return нет;
    }

    /*********************************************
	* Calling function f.
	* Check the -ness, i.e. if we're in a  function
	* we can only call other  functions.
	* Возвращает да if error occurs.
	*/
    extern (D) final бул checkNogc(Scope* sc, FuncDeclaration f)
    {
        if (!sc.func)
            return нет;
        if (sc.func == f)
            return нет;
        if (sc.intypeof == 1)
            return нет;
        if (sc.flags & (SCOPE.ctfe | SCOPE.debug_))
            return нет;

        if (!f.isNogc())
        {
            if (sc.flags & SCOPE.compile ? sc.func.isNogcBypassingInference() : sc.func.setGC())
            {
                if (место.номстр == 0) // e.g. implicitly generated dtor
                    место = sc.func.место;

                // Lowered non-'d hooks will print their own error message inside of nogc.d (NOGCVisitor.посети(CallExp e)),
                // so don't print anything to avoid double error messages.
                if (!(f.идент == Id._d_HookTraceImpl || f.идент == Id._d_arraysetlengthT))
                    выведиОшибку("`` %s `%s` cannot call non- %s `%s`",
								 sc.func.вид(), sc.func.toPrettyChars(), f.вид(), f.toPrettyChars());
                return да;
            }
        }
        return нет;
    }

    /********************************************
	* Check that the postblit is callable if t is an массив of structs.
	* Возвращает да if error happens.
	*/
    extern (D) final бул checkPostblit(Scope* sc, Тип t)
    {
        if (auto ts = t.baseElemOf().isTypeStruct())
        {
            if (глоб2.парамы.useTypeInfo)
            {
                // https://issues.dlang.org/show_bug.cgi?ид=11395
                // Require TypeInfo generation for массив concatenation
                semanticTypeInfo(sc, t);
            }

            StructDeclaration sd = ts.sym;
            if (sd.postblit)
            {
                if (sd.postblit.checkDisabled(место, sc))
                    return да;

                //checkDeprecated(sc, sd.postblit);        // necessary?
                checkPurity(sc, sd.postblit);
                checkSafety(sc, sd.postblit);
                checkNogc(sc, sd.postblit);
                //checkAccess(sd, место, sc, sd.postblit);   // necessary?
                return нет;
            }
        }
        return нет;
    }

    extern (D) final бул checkRightThis(Scope* sc)
    {
        if (op == ТОК2.error)
            return да;
        if (op == ТОК2.variable && тип.ty != Terror)
        {
            VarExp ve = cast(VarExp)this;
            if (isNeedThisScope(sc, ve.var))
            {
                //printf("checkRightThis sc.intypeof = %d, ad = %p, func = %p, fdthis = %p\n",
                //        sc.intypeof, sc.getStructClassScope(), func, fdthis);
                выведиОшибку("need `this` for `%s` of тип `%s`", ve.var.вТкст0(), ve.var.тип.вТкст0());
                return да;
            }
        }
        return нет;
    }

    /*******************************
	* Check whether the Выражение allows RMW operations, error with rmw operator diagnostic if not.
	* ex is the RHS Выражение, or NULL if ++/-- is используется (for diagnostics)
	* Возвращает да if error occurs.
	*/
    extern (D) final бул checkReadModifyWrite(ТОК2 rmwOp, Выражение ex = null)
    {
        //printf("Выражение::checkReadModifyWrite() %s %s", вТкст0(), ex ? ex.вТкст0() : "");
        if (!тип || !тип.isShared() || тип.isTypeStruct() || тип.isTypeClass())
            return нет;

        // atomicOp uses opAssign (+=/-=) rather than opOp (++/--) for the CT ткст literal.
        switch (rmwOp)
        {
			case ТОК2.plusPlus:
			case ТОК2.prePlusPlus:
				rmwOp = ТОК2.addAssign;
				break;
			case ТОК2.minusMinus:
			case ТОК2.preMinusMinus:
				rmwOp = ТОК2.minAssign;
				break;
			default:
				break;
        }

        выведиОшибку("читай-modify-пиши operations are not allowed for `shared` variables. Use `core.atomic.atomicOp!\"%s\"(%s, %s)` instead.", Сема2.вТкст0(rmwOp), вТкст0(), ex ? ex.вТкст0() : "1");

		return да;
    }

    /***************************************
	* Параметры:
	*      sc:     scope
	*      флаг:   1: do not issue error message for invalid modification
	* Возвращает:
	*      Whether the тип is modifiable
	*/
    Modifiable checkModifiable(Scope* sc, цел флаг = 0)
    {
        return тип ? Modifiable.yes : Modifiable.no; // default modifiable
    }

    /*****************************
	* If Выражение can be tested for да or нет,
	* returns the modified Выражение.
	* Otherwise returns ErrorExp.
	*/
    Выражение toBoolean(Scope* sc)
    {
        // Default is 'yes' - do nothing
        Выражение e = this;
        Тип t = тип;
        Тип tb = тип.toBasetype();
        Тип att = null;

        while (1)
        {
            // Structs can be converted to бул using opCast(бул)()
            if (auto ts = tb.isTypeStruct())
            {
                AggregateDeclaration ad = ts.sym;
                /* Don't really need to check for opCast first, but by doing so we
				* get better error messages if it isn't there.
				*/
                if (ДСимвол fd = search_function(ad, Id._cast))
                {
                    e = new CastExp(место, e, Тип.tбул);
                    e = e.ВыражениеSemantic(sc);
                    return e;
                }

                // Forward to aliasthis.
                if (ad.aliasthis && tb != att)
                {
                    if (!att && tb.checkAliasThisRec())
                        att = tb;
                    e = resolveAliasThis(sc, e);
                    t = e.тип;
                    tb = e.тип.toBasetype();
                    continue;
                }
            }
            break;
        }

        if (!t.isBoolean())
        {
            if (tb != Тип.terror)
                выведиОшибку("Выражение `%s` of тип `%s` does not have a булean значение", вТкст0(), t.вТкст0());
            return new ErrorExp();
        }
        return e;
    }

    /************************************************
	* Destructors are attached to VarDeclarations.
	* Hence, if Выражение returns a temp that needs a destructor,
	* make sure and создай a VarDeclaration for that temp.
	*/
    Выражение addDtorHook(Scope* sc)
    {
        return this;
    }

    /******************************
	* Take address of Выражение.
	*/
    final Выражение addressOf()
    {
        //printf("Выражение::addressOf()\n");
        debug
        {
            assert(op == ТОК2.error || isLvalue());
        }
        Выражение e = new AddrExp(место, this, тип.pointerTo());
        return e;
    }

    /******************************
	* If this is a reference, dereference it.
	*/
    final Выражение deref()
    {
        //printf("Выражение::deref()\n");
        // тип could be null if forward referencing an 'auto' variable
        if (тип)
            if (auto tr = тип.isTypeReference())
            {
                Выражение e = new PtrExp(место, this, tr.следщ);
                return e;
            }
        return this;
    }

    final Выражение optimize(цел результат, бул keepLvalue = нет)
    {
        return Выражение_optimize(this, результат, keepLvalue);
    }

    // Entry point for CTFE.
    // A compile-time результат is required. Give an error if not possible
    final Выражение ctfeInterpret()
    {
        return .ctfeInterpret(this);
    }

    final цел isConst()
    {
        return .isConst(this);
    }

    /********************************
	* Does this Выражение statically evaluate to a булean 'результат' (да or нет)?
	*/
    бул isBool(бул результат)
    {
        return нет;
    }

    бул hasCode()
    {
        return да;
    }

	//В Д2 появились новые определители return, inout и проч. В Д1 их нет.
	//  Пробуем представить как  
	//IntegerExp  isIntegerExp() {  return op == ТОК2.int64 ? ТипВозврата2!(this) : null; }
	// Проверка будет возможна только после компиляции DMD 2.

	///Извлечено из Динрусовского tpl.traits
	template ТипВозврата2(alias дг)
	{
		alias ТипВозврата2!(typeof(дг), проц) ТипВозврата2;
	}

	///Извлечено из Динрусовского tpl.traits
	template ТипВозврата2(дг, dummy = проц)
	{
		static if (is(дг R == return))
			alias R ТипВозврата2;
		else static if (is(дг Т : Т*))
			alias ТипВозврата2!(Т, проц) ТипВозврата2;
		else static if (is(дг S == struct))
			alias ТипВозврата2!(typeof(&дг.opCall), проц) ТипВозврата2;
		else static if (is(дг C == class))
			alias ТипВозврата2!(typeof(&дг.opCall), проц) ТипВозврата2;
	}

    final  
    {
        IntegerExp  isIntegerExp() {  return op == ТОК2.int64 ? ТипВозврата2!(this) : null; }
        ErrorExp    isErrorExp() {  return op == ТОК2.error ? ТипВозврата2!(this) : null; }
        VoidInitExp isVoidInitExp()  { return op == ТОК2.void_ ? ТипВозврата2!(this) : null; }
        RealExp     isRealExp()  { return op == ТОК2.float64 ? ТипВозврата2!(this) : null; }
        ComplexExp  isComplexExp()  { return op == ТОК2.complex80 ? ТипВозврата2!(this) : null; }
        IdentifierExp isIdentifierExp()  { return op == ТОК2.идентификатор ? ТипВозврата2!(this) : null; }
        DollarExp   isDollarExp()  { return op == ТОК2.dollar ? ТипВозврата2!(this) : null; }
        DsymbolExp  isDsymbolExp()  { return op == ТОК2.dSymbol ? ТипВозврата2!(this) : null; }
        ThisExp     isThisExp()  { return op == ТОК2.this_ ? ТипВозврата2!(this) : null; }
        SuperExp    isSuperExp()  { return op == ТОК2.super_ ? ТипВозврата2!(this) : null; }
        NullExp     isNullExp()  { return op == ТОК2.null_ ? ТипВозврата2!(this) : null; }
        StringExp   isStringExp()  { return op == ТОК2.string_ ? ТипВозврата2!(this) : null; }
        TupleExp    isTupleExp()  { return op == ТОК2.кортеж ? ТипВозврата2!(this) : null; }
        ArrayLiteralExp isArrayLiteralExp()  { return op == ТОК2.arrayLiteral ? ТипВозврата2!(this) : null; }
        AssocArrayLiteralExp isAssocArrayLiteralExp()  { return op == ТОК2.assocArrayLiteral ? ТипВозврата2!(this) : null; }
        StructLiteralExp isStructLiteralExp()  { return op == ТОК2.structLiteral ? ТипВозврата2!(this) : null; }
        TypeExp      isTypeExp()  { return op == ТОК2.тип ? ТипВозврата2!(this) : null; }
        ScopeExp     isScopeExp()  { return op == ТОК2.scope_ ? ТипВозврата2!(this) : null; }
        TemplateExp  isTemplateExp()  { return op == ТОК2.template_ ? ТипВозврата2!(this) : null; }
        NewExp isNewExp()  { return op == ТОК2.new_ ? ТипВозврата2!(this) : null; }
        NewAnonClassExp isNewAnonClassExp()  { return op == ТОК2.newAnonymousClass ? ТипВозврата2!(this) : null; }
        SymOffExp    isSymOffExp()  { return op == ТОК2.symbolOffset ? ТипВозврата2!(this) : null; }
        VarExp       isVarExp()  { return op == ТОК2.variable ? ТипВозврата2!(this) : null; }
        OverExp      isOverExp()  { return op == ТОК2.overloadSet ? ТипВозврата2!(this) : null; }
        FuncExp      isFuncExp()  { return op == ТОК2.function_ ? ТипВозврата2!(this) : null; }
        DeclarationExp isDeclarationExp()  { return op == ТОК2.declaration ? ТипВозврата2!(this) : null; }
        TypeidExp    isTypeidExp()  { return op == ТОК2.typeid_ ? ТипВозврата2!(this) : null; }
        TraitsExp    isTraitsExp()  { return op == ТОК2.traits ? ТипВозврата2!(this) : null; }
        HaltExp      isHaltExp()  { return op == ТОК2.halt ? ТипВозврата2!(this) : null; }
        IsExp        isExp()  { return op == ТОК2.is_ ? ТипВозврата2!(this) : null; }
        CompileExp   isCompileExp()  { return op == ТОК2.mixin_ ? ТипВозврата2!(this) : null; }
        ImportExp    isImportExp()  { return op == ТОК2.import_ ? ТипВозврата2!(this) : null; }
        AssertExp    isAssertExp()  { return op == ТОК2.assert_ ? ТипВозврата2!(this) : null; }
        DotIdExp     isDotIdExp()  { return op == ТОК2.dotIdentifier ? ТипВозврата2!(this) : null; }
        DotTemplateExp isDotTemplateExp()  { return op == ТОК2.dotTemplateDeclaration ? ТипВозврата2!(this) : null; }
        DotVarExp    isDotVarExp()  { return op == ТОК2.dotVariable ? ТипВозврата2!(this) : null; }
        DotTemplateInstanceExp isDotTemplateInstanceExp()  { return op == ТОК2.dotTemplateInstance ? ТипВозврата2!(this) : null; }
        DelegateExp  isDelegateExp()  { return op == ТОК2.delegate_ ? ТипВозврата2!(this) : null; }
        DotTypeExp   isDotTypeExp()  { return op == ТОК2.dotType ? ТипВозврата2!(this) : null; }
        CallExp      isCallExp()  { return op == ТОК2.call ? ТипВозврата2!(this) : null; }
        AddrExp      isAddrExp()  { return op == ТОК2.address ? ТипВозврата2!(this) : null; }
        PtrExp       isPtrExp()  { return op == ТОК2.star ? ТипВозврата2!(this) : null; }
        NegExp       isNegExp()  { return op == ТОК2.negate ? ТипВозврата2!(this) : null; }
        UAddExp      isUAddExp()  { return op == ТОК2.uadd ? ТипВозврата2!(this) : null; }
        ComExp       isComExp()  { return op == ТОК2.tilde ? ТипВозврата2!(this) : null; }
        NotExp       isNotExp()  { return op == ТОК2.not ? ТипВозврата2!(this) : null; }
        DeleteExp    isDeleteExp()  { return op == ТОК2.delete_ ? ТипВозврата2!(this) : null; }
        CastExp      isCastExp()  { return op == ТОК2.cast_ ? ТипВозврата2!(this) : null; }
        VectorExp    isVectorExp()  { return op == ТОК2.vector ? ТипВозврата2!(this) : null; }
        VectorArrayExp isVectorArrayExp()  { return op == ТОК2.vectorArray ? ТипВозврата2!(this) : null; }
        SliceExp     isSliceExp()  { return op == ТОК2.slice ? ТипВозврата2!(this) : null; }
        ArrayLengthExp isArrayLengthExp()  { return op == ТОК2.arrayLength ? ТипВозврата2!(this) : null; }
        ArrayExp     isArrayExp()  { return op == ТОК2.массив ? ТипВозврата2!(this) : null; }
        DotExp       isDotExp()  { return op == ТОК2.dot ? ТипВозврата2!(this) : null; }
        CommaExp     isCommaExp()  { return op == ТОК2.comma ? ТипВозврата2!(this) : null; }
        IntervalExp  isIntervalExp()  { return op == ТОК2.interval ? ТипВозврата2!(this) : null; }
        DelegatePtrExp     isDelegatePtrExp()  { return op == ТОК2.delegatePointer ? ТипВозврата2!(this) : null; }
        DelegateFuncptrExp isDelegateFuncptrExp()  { return op == ТОК2.delegateFunctionPointer ? ТипВозврата2!(this) : null; }
        IndexExp     isIndexExp()  { return op == ТОК2.index ? ТипВозврата2!(this) : null; }
        PostExp      isPostExp()   { return (op == ТОК2.plusPlus || op == ТОК2.minusMinus) ? ТипВозврата2!(this) : null; }
        PreExp       isPreExp()    { return (op == ТОК2.prePlusPlus || op == ТОК2.preMinusMinus) ? ТипВозврата2!(this) : null; }
        AssignExp    isAssignExp()     { return op == ТОК2.assign ? ТипВозврата2!(this) : null; }
        ConstructExp isConstructExp()  { return op == ТОК2.construct ? ТипВозврата2!(this) : null; }
        BlitExp      isBlitExp()       { return op == ТОК2.blit ? ТипВозврата2!(this) : null; }
        AddAssignExp isAddAssignExp()  { return op == ТОК2.addAssign ? ТипВозврата2!(this) : null; }
        MinAssignExp isMinAssignExp()  { return op == ТОК2.minAssign ? ТипВозврата2!(this) : null; }
        MulAssignExp isMulAssignExp()  { return op == ТОК2.mulAssign ? ТипВозврата2!(this) : null; }

        DivAssignExp isDivAssignExp()  { return op == ТОК2.divAssign ? ТипВозврата2!(this) : null; }
        ModAssignExp isModAssignExp()  { return op == ТОК2.modAssign ? ТипВозврата2!(this) : null; }
        AndAssignExp isAndAssignExp()  { return op == ТОК2.andAssign ? ТипВозврата2!(this) : null; }
        OrAssignExp  isOrAssignExp()   { return op == ТОК2.orAssign ? ТипВозврата2!(this) : null; }
        XorAssignExp isXorAssignExp()  { return op == ТОК2.xorAssign ? ТипВозврата2!(this) : null; }
        PowAssignExp isPowAssignExp()  { return op == ТОК2.powAssign ? ТипВозврата2!(this) : null; }

        ShlAssignExp  isShlAssignExp()   { return op == ТОК2.leftShiftAssign ? ТипВозврата2!(this) : null; }
        ShrAssignExp  isShrAssignExp()   { return op == ТОК2.rightShiftAssign ? ТипВозврата2!(this) : null; }
        UshrAssignExp isUshrAssignExp()  { return op == ТОК2.unsignedRightShiftAssign ? ТипВозврата2!(this) : null; }

        CatAssignExp isCatAssignExp()  { return op == ТОК2.concatenateAssign
			? ТипВозврата2!(this)
			: null; }

        CatElemAssignExp isCatElemAssignExp()  { return op == ТОК2.concatenateElemAssign
			? ТипВозврата2!(this)
			: null; }

        CatDcharAssignExp isCatDcharAssignExp()  { return op == ТОК2.concatenateDcharAssign
			? ТипВозврата2!(this)
			: null; }

        AddExp      isAddExp()  { return op == ТОК2.add ? ТипВозврата2!(this) : null; }
        MinExp      isMinExp()  { return op == ТОК2.min ? ТипВозврата2!(this) : null; }
        CatExp      isCatExp()  { return op == ТОК2.concatenate ? ТипВозврата2!(this) : null; }
        MulExp      isMulExp()  { return op == ТОК2.mul ? ТипВозврата2!(this) : null; }
        DivExp      isDivExp()  { return op == ТОК2.div ? ТипВозврата2!(this) : null; }
        ModExp      isModExp()  { return op == ТОК2.mod ? ТипВозврата2!(this) : null; }
        PowExp      isPowExp()  { return op == ТОК2.pow ? ТипВозврата2!(this) : null; }
        ShlExp      isShlExp()  { return op == ТОК2.leftShift ? ТипВозврата2!(this) : null; }
        ShrExp      isShrExp()  { return op == ТОК2.rightShift ? ТипВозврата2!(this) : null; }
        UshrExp     isUshrExp()  { return op == ТОК2.unsignedRightShift ? ТипВозврата2!(this) : null; }
        AndExp      isAndExp()  { return op == ТОК2.and ? ТипВозврата2!(this) : null; }
        OrExp       isOrExp()  { return op == ТОК2.or ? ТипВозврата2!(this) : null; }
        XorExp      isXorExp()  { return op == ТОК2.xor ? ТипВозврата2!(this) : null; }
        LogicalExp  isLogicalExp()  { return (op == ТОК2.andAnd || op == ТОК2.orOr) ? ТипВозврата2!(this) : null; }
        //CmpExp    isCmpExp()  { return op == ТОК2. ? ТипВозврата2!(this) : null; }
        InExp       isInExp()  { return op == ТОК2.in_ ? ТипВозврата2!(this) : null; }
        RemoveExp   isRemoveExp()  { return op == ТОК2.удали ? ТипВозврата2!(this) : null; }
        EqualExp    isEqualExp()  { return (op == ТОК2.equal || op == ТОК2.notEqual) ? ТипВозврата2!(this) : null; }
        IdentityExp isIdentityExp()  { return (op == ТОК2.identity || op == ТОК2.notIdentity) ? ТипВозврата2!(this) : null; }
        CondExp     isCondExp() { return op == ТОК2.question ? ТипВозврата2!(this) : null; }

        DefaultInitExp    isDefaultInitExp() { return op == ТОК2.default_ ? ТипВозврата2!(this) : null; }
        FileInitExp       isFileInitExp() { ТипВозврата2!(this) (op == ТОК2.файл || op == ТОК2.fileFullPath) ? ТипВозврата2!(this) : null; }
        LineInitExp       isLineInitExp() { return op == ТОК2.line ? ТипВозврата2!(this) : null; }
        ModuleInitExp     isModuleInitExp() { return op == ТОК2.moduleString ? ТипВозврата2!(this) : null; }
        FuncInitExp       isFuncInitExp() { return op == ТОК2.functionString ? ТипВозврата2!(this) : null; }
        PrettyFuncInitExp isPrettyFuncInitExp() { return op == ТОК2.prettyFunction ? ТипВозврата2!(this) : null; }
        ClassReferenceExp isClassReferenceExp() { return op == ТОК2.classReference ? ТипВозврата2!(this) : null; }
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class IntegerExp : Выражение
{
    private dinteger_t значение;

    this(ref Место место, dinteger_t значение, Тип тип)
    {
        super(место, ТОК2.int64, __traits(classInstanceSize, IntegerExp));
        //printf("IntegerExp(значение = %lld, тип = '%s')\n", значение, тип ? тип.вТкст0() : "");
        assert(тип);
        if (!тип.isscalar())
        {
            //printf("%s, место = %d\n", вТкст0(), место.номстр);
            if (тип.ty != Terror)
                выведиОшибку("integral constant must be scalar тип, not `%s`", тип.вТкст0());
            тип = Тип.terror;
        }
        this.тип = тип;
        this.значение = normalize(тип.toBasetype().ty, значение);
    }

    this(dinteger_t значение)
    {
        super(Место.initial, ТОК2.int64, __traits(classInstanceSize, IntegerExp));
        this.тип = Тип.tint32;
        this.значение = cast(d_int32)значение;
    }

    static IntegerExp создай(Место место, dinteger_t значение, Тип тип)
    {
        return new IntegerExp(место, значение, тип);
    }

    // Same as создай, but doesn't размести memory.
    static проц emplace(UnionExp* pue, Место место, dinteger_t значение, Тип тип)
    {
        emplaceExp!(IntegerExp)(pue, место, значение, тип);
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        if (auto ne = (cast(Выражение)o).isIntegerExp())
        {
            if (тип.toHeadMutable().равен(ne.тип.toHeadMutable()) && значение == ne.значение)
            {
                return да;
            }
        }
        return нет;
    }

    override dinteger_t toInteger()
    {
        // normalize() is necessary until we fix all the paints of 'тип'
        return значение = normalize(тип.toBasetype().ty, значение);
    }

    override real_t toReal()
    {
        // normalize() is necessary until we fix all the paints of 'тип'
        const ty = тип.toBasetype().ty;
        const val = normalize(ty, значение);
        значение = val;
        return (ty == Tuns64)
            ? real_t(cast(d_uns64)val)
            : real_t(cast(d_int64)val);
    }

    override real_t toImaginary()
    {
        return CTFloat.нуль;
    }

    override complex_t toComplex()
    {
        return complex_t(toReal());
    }

    override бул isBool(бул результат)
    {
        бул r = toInteger() != 0;
        return результат ? r : !r;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (!e)
            e = this;
        else if (!место.isValid())
            место = e.место;
        e.выведиОшибку("cannot modify constant `%s`", e.вТкст0());
        return new ErrorExp();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    dinteger_t getInteger()
    {
        return значение;
    }

    проц setInteger(dinteger_t значение)
    {
        this.значение = normalize(тип.toBasetype().ty, значение);
    }

    extern (D) static dinteger_t normalize(TY ty, dinteger_t значение)
    {
        /* 'Normalize' the значение of the integer to be in range of the тип
		*/
        dinteger_t результат;
        switch (ty)
        {
			case Tbool:
				результат = (значение != 0);
				break;

			case Tint8:
				результат = cast(d_int8)значение;
				break;

			case Tchar:
			case Tuns8:
				результат = cast(d_uns8)значение;
				break;

			case Tint16:
				результат = cast(d_int16)значение;
				break;

			case Twchar:
			case Tuns16:
				результат = cast(d_uns16)значение;
				break;

			case Tint32:
				результат = cast(d_int32)значение;
				break;

			case Tdchar:
			case Tuns32:
				результат = cast(d_uns32)значение;
				break;

			case Tint64:
				результат = cast(d_int64)значение;
				break;

			case Tuns64:
				результат = cast(d_uns64)значение;
				break;

			case Tpointer:
				if (target.ptrsize == 8)
					goto case Tuns64;
				if (target.ptrsize == 4)
					goto case Tuns32;
				if (target.ptrsize == 2)
					goto case Tuns16;
				assert(0);

			default:
				break;
        }
        return результат;
    }

    override Выражение syntaxCopy()
    {
        return this;
    }

    /**
	* Use this instead of creating new instances for commonly используется literals
	* such as 0 or 1.
	*
	* Параметры:
	*      v = The значение of the Выражение
	* Возвращает:
	*      A static instance of the Выражение, typed as `Tint32`.
	*/
    static IntegerExp literal(цел v)()
    {
		IntegerExp theConstant;
        if (!theConstant)
            theConstant = new IntegerExp(v);
        return theConstant;
    }

    /**
	* Use this instead of creating new instances for commonly используется булs.
	*
	* Параметры:
	*      b = The значение of the Выражение
	* Возвращает:
	*      A static instance of the Выражение, typed as `Тип.tбул`.
	*/
    static IntegerExp createBool(бул b)
    {
		IntegerExp trueExp, falseExp;
        if (!trueExp)
        {
            trueExp = new IntegerExp(Место.initial, 1, Тип.tбул);
            falseExp = new IntegerExp(Место.initial, 0, Тип.tбул);
        }
        return b ? trueExp : falseExp;
    }
}

/***********************************************************
* Use this Выражение for error recovery.
* It should behave as a 'sink' to prevent further cascaded error messages.
*/
final class ErrorExp : Выражение
{
    this()
    {
        if (глоб2.errors == 0 && глоб2.gaggedErrors == 0)
        {
			/* Unfortunately, errors can still leak out of gagged errors,
			* and we need to set the error count to prevent bogus code
			* generation. At least give a message.
			*/
			выведиОшибку("unknown, please файл report on issues.dlang.org");
        }

        super(Место.initial, ТОК2.error, __traits(classInstanceSize, ErrorExp));
        тип = Тип.terror;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

	ErrorExp errorexp; // handy shared значение
}


/***********************************************************
* An uninitialized значение,
* generated from проц initializers.
*/
final class VoidInitExp : Выражение
{
    VarDeclaration var; /// the variable from where the проц значение came from, null if not known
	/// Useful for error messages

    this(VarDeclaration var)
    {
        super(var.место, ТОК2.void_, __traits(classInstanceSize, VoidInitExp));
        this.var = var;
        this.тип = var.тип;
    }

    override ткст0 вТкст0()
    {
        return "проц";
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}


/***********************************************************
*/
final class RealExp : Выражение
{
    real_t значение;

    this(ref Место место, real_t значение, Тип тип)
    {
        super(место, ТОК2.float64, __traits(classInstanceSize, RealExp));
        //printf("RealExp::RealExp(%Lg)\n", значение);
        this.значение = значение;
        this.тип = тип;
    }

    static RealExp создай(Место место, real_t значение, Тип тип)
    {
        return new RealExp(место, значение, тип);
    }

    // Same as создай, but doesn't размести memory.
    static проц emplace(UnionExp* pue, Место место, real_t значение, Тип тип)
    {
        emplaceExp!(RealExp)(pue, место, значение, тип);
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        if (auto ne = (cast(Выражение)o).isRealExp())
        {
            if (тип.toHeadMutable().равен(ne.тип.toHeadMutable()) && RealIdentical(значение, ne.значение))
            {
                return да;
            }
        }
        return нет;
    }

    override dinteger_t toInteger()
    {
        return cast(sinteger_t)toReal();
    }

    override uinteger_t toUInteger()
    {
        return cast(uinteger_t)toReal();
    }

    override real_t toReal()
    {
        return тип.isreal() ? значение : CTFloat.нуль;
    }

    override real_t toImaginary()
    {
        return тип.isreal() ? CTFloat.нуль : значение;
    }

    override complex_t toComplex()
    {
        return complex_t(toReal(), toImaginary());
    }

    override бул isBool(бул результат)
    {
        return результат ? cast(бул)значение : !cast(бул)значение;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ComplexExp : Выражение
{
    complex_t значение;

    this(ref Место место, complex_t значение, Тип тип)
    {
        super(место, ТОК2.complex80, __traits(classInstanceSize, ComplexExp));
        this.значение = значение;
        this.тип = тип;
        //printf("ComplexExp::ComplexExp(%s)\n", вТкст0());
    }

    static ComplexExp создай(Место место, complex_t значение, Тип тип)
    {
        return new ComplexExp(место, значение, тип);
    }

    // Same as создай, but doesn't размести memory.
    static проц emplace(UnionExp* pue, Место место, complex_t значение, Тип тип)
    {
        emplaceExp!(ComplexExp)(pue, место, значение, тип);
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        if (auto ne = (cast(Выражение)o).isComplexExp())
        {
            if (тип.toHeadMutable().равен(ne.тип.toHeadMutable()) && RealIdentical(creall(значение), creall(ne.значение)) && RealIdentical(cimagl(значение), cimagl(ne.значение)))
            {
                return да;
            }
        }
        return нет;
    }

    override dinteger_t toInteger()
    {
        return cast(sinteger_t)toReal();
    }

    override uinteger_t toUInteger()
    {
        return cast(uinteger_t)toReal();
    }

    override real_t toReal()
    {
        return creall(значение);
    }

    override real_t toImaginary()
    {
        return cimagl(значение);
    }

    override complex_t toComplex()
    {
        return значение;
    }

    override бул isBool(бул результат)
    {
        if (результат)
            return cast(бул)значение;
        else
            return !значение;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
class IdentifierExp : Выражение
{
    Идентификатор2 идент;

    this(ref Место место, Идентификатор2 идент)
    {
        super(место, ТОК2.идентификатор, __traits(classInstanceSize, IdentifierExp));
        this.идент = идент;
    }

    static IdentifierExp создай(Место место, Идентификатор2 идент)
    {
        return new IdentifierExp(место, идент);
    }

    override final бул isLvalue()
    {
        return да;
    }

    override final Выражение toLvalue(Scope* sc, Выражение e)
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
final class DollarExp : IdentifierExp
{
    this(ref Место место)
    {
        super(место, Id.dollar);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Won't be generated by parser.
*/
final class DsymbolExp : Выражение
{
    ДСимвол s;
    бул hasOverloads;

    this(ref Место место, ДСимвол s, бул hasOverloads = да)
    {
        super(место, ТОК2.dSymbol, __traits(classInstanceSize, DsymbolExp));
        this.s = s;
        this.hasOverloads = hasOverloads;
    }

    override бул isLvalue()
    {
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#this
*/
class ThisExp : Выражение
{
    VarDeclaration var;

    this(ref Место место)
    {
        super(место, ТОК2.this_, __traits(classInstanceSize, ThisExp));
        //printf("ThisExp::ThisExp() место = %d\n", место.номстр);
    }

    this(ref Место место, ТОК2 tok)
    {
        super(место, tok, __traits(classInstanceSize, ThisExp));
        //printf("ThisExp::ThisExp() место = %d\n", место.номстр);
    }

    override Выражение syntaxCopy()
    {
        auto r = cast(ThisExp) super.syntaxCopy();
        // require new semantic (possibly new `var` etc.)
        r.тип = null;
        r.var = null;
        return r;
    }

    override final бул isBool(бул результат)
    {
        return результат;
    }

    override final бул isLvalue()
    {
        // Class `this` should be an rvalue; struct `this` should be an lvalue.
        return тип.toBasetype().ty != Tclass;
    }

    override final Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (тип.toBasetype().ty == Tclass)
        {
            // Class `this` is an rvalue; struct `this` is an lvalue.
            return Выражение.toLvalue(sc, e);
        }
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#super
*/
final class SuperExp : ThisExp
{
    this(ref Место место)
    {
        super(место, ТОК2.super_);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#null
*/
final class NullExp : Выражение
{
    ббайт committed;    // !=0 if тип is committed

    this(ref Место место, Тип тип = null)
    {
        super(место, ТОК2.null_, __traits(classInstanceSize, NullExp));
        this.тип = тип;
    }

    override бул равен(КорневойОбъект o)
    {
        if (auto e = o.выражение_ли())
        {
            if (e.op == ТОК2.null_ && тип.равен(e.тип))
            {
                return да;
            }
        }
        return нет;
    }

    override бул isBool(бул результат)
    {
        return результат ? нет : да;
    }

    override StringExp вТкстExp()
    {
        if (implicitConvTo(Тип.tstring))
        {
            auto se = new StringExp(место, (cast(сим*)mem.xcalloc(1, 1))[0 .. 0]);
            se.тип = Тип.tstring;
            return se;
        }
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#string_literals
*/
final class StringExp : Выражение
{
    private union
    {
        ткст0 ткст;   // if sz == 1
        wchar* wstring; // if sz == 2
        dchar* dstring; // if sz == 4
    }                   // (const if ownedByCtfe == OwnedBy.code)
    т_мера len;         // number of code units
    ббайт sz = 1;       // 1: сим, 2: wchar, 4: dchar
    ббайт committed;    // !=0 if тип is committed
    const сим NoPostfix = 0;
    сим postfix = NoPostfix;   // 'c', 'w', 'd'
    OwnedBy ownedByCtfe = OwnedBy.code;

    this(ref Место место, проц[] ткст)
    {
        super(место, ТОК2.string_, __traits(classInstanceSize, StringExp));
        this.ткст = cast(сим*)ткст.ptr; // note that this.ткст should be const
        this.len = ткст.length;
        this.sz = 1;                    // work around LDC bug #1286
    }

    this(ref Место место, проц[] ткст, т_мера len, ббайт sz, сим postfix = NoPostfix)
    {
        super(место, ТОК2.string_, __traits(classInstanceSize, StringExp));
        this.ткст = cast(сим*)ткст.ptr; // note that this.ткст should be const
        this.len = len;
        this.sz = sz;
        this.postfix = postfix;
    }

    static StringExp создай(Место место, ткст0 s)
    {
        return new StringExp(место, s.вТкстД());
    }

    static StringExp создай(Место место, ук ткст, т_мера len)
    {
        return new StringExp(место, ткст[0 .. len]);
    }

    // Same as создай, but doesn't размести memory.
    static проц emplace(UnionExp* pue, Место место, ткст0 s)
    {
        emplaceExp!(StringExp)(pue, место, s.вТкстД());
    }

    extern (D) static проц emplace(UnionExp* pue, Место место, проц[] ткст)
    {
        emplaceExp!(StringExp)(pue, место, ткст);
    }

    extern (D) static проц emplace(UnionExp* pue, Место место, проц[] ткст, т_мера len, ббайт sz, сим postfix)
    {
        emplaceExp!(StringExp)(pue, место, ткст, len, sz, postfix);
    }

    override бул равен(КорневойОбъект o)
    {
        //printf("StringExp::равен('%s') %s\n", o.вТкст0(), вТкст0());
        if (auto e = o.выражение_ли())
        {
            if (auto se = e.isStringExp())
            {
                return compare(se) == 0;
            }
        }
        return нет;
    }

    /**********************************
	* Return the number of code units the ткст would be if it were re-encoded
	* as tynto.
	* Параметры:
	*      tynto = code unit тип of the target encoding
	* Возвращает:
	*      number of code units
	*/
    т_мера numberOfCodeUnits(цел tynto = 0)
    {
        цел encSize;
        switch (tynto)
        {
            case 0:      return len;
            case Tchar:  encSize = 1; break;
            case Twchar: encSize = 2; break;
            case Tdchar: encSize = 4; break;
            default:
                assert(0);
        }
        if (sz == encSize)
            return len;

        т_мера результат = 0;
        dchar c;

        switch (sz)
        {
			case 1:
				for (т_мера u = 0; u < len;)
				{
					if(auto s = utf_decodeChar(ткст[0 .. len], u, c))
					{
						выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
						return 0;
					}
					результат += utf_codeLength(encSize, c);
				}
				break;

			case 2:
				for (т_мера u = 0; u < len;)
				{
					if(auto s = utf_decodeWchar(wstring[0 .. len], u, c))
					{
						выведиОшибку("%.*s", cast(цел)s.length, s.ptr);
						return 0;
					}
					результат += utf_codeLength(encSize, c);
				}
				break;

			case 4:
				foreach (u; new бцел[0 .. len])
				{
					результат += utf_codeLength(encSize, dstring[u]);
				}
				break;

			default:
				assert(0);
        }
        return результат;
    }

    /**********************************************
	* Write the contents of the ткст to dest.
	* Use numberOfCodeUnits() to determine size of результат.
	* Параметры:
	*  dest = destination
	*  tyto = encoding тип of the результат
	*  нуль = add terminating 0
	*/
    проц writeTo(ук dest, бул нуль, цел tyto = 0)
    {
        цел encSize;
        switch (tyto)
        {
            case 0:      encSize = sz; break;
            case Tchar:  encSize = 1; break;
            case Twchar: encSize = 2; break;
            case Tdchar: encSize = 4; break;
            default:
                assert(0);
        }
        if (sz == encSize)
        {
            memcpy(dest, ткст, len * sz);
            if (нуль)
                memset(dest + len * sz, 0, sz);
        }
        else
            assert(0);
    }

    /*********************************************
	* Get the code unit at index i
	* Параметры:
	*  i = index
	* Возвращает:
	*  code unit at index i
	*/
    dchar getCodeUnit(т_мера i) 
    {
        assert(i < len);
        switch (sz)
        {
			case 1:
				return ткст[i];
			case 2:
				return wstring[i];
			case 4:
				return dstring[i];
        }
    }

    /*********************************************
	* Set the code unit at index i to c
	* Параметры:
	*  i = index
	*  c = code unit to set it to
	*/
    проц setCodeUnit(т_мера i, dchar c)
    {
        assert(i < len);
        switch (sz)
        {
			case 1:
				ткст[i] = cast(сим)c;
				break;
			case 2:
				wstring[i] = cast(wchar)c;
				break;
			case 4:
				dstring[i] = c;
				break;
        }
    }

    override StringExp вТкстExp()
    {
        return this;
    }

    /****************************************
	* Convert ткст to ткст.
	*/
    StringExp toUTF8(Scope* sc)
    {
        if (sz != 1)
        {
            // Convert to UTF-8 ткст
            committed = 0;
            Выражение e = castTo(sc, Тип.tchar.arrayOf());
            e = e.optimize(WANTvalue);
            auto se = e.isStringExp();
            assert(se.sz == 1);
            return se;
        }
        return this;
    }

    цел compare(StringExp se2)   
    {
        //printf("StringExp::compare()\n");
        // Used to sort case инструкция Выражения so we can do an efficient lookup

        const len1 = len;
        const len2 = se2.len;

        //printf("sz = %d, len1 = %d, len2 = %d\n", sz, (цел)len1, (цел)len2);
        if (len1 == len2)
        {
            switch (sz)
            {
				case 1:
					return memcmp(ткст, se2.ткст, len1);

				case 2:
					{
						wchar* s1 = cast(wchar*)ткст;
						wchar* s2 = cast(wchar*)se2.ткст;
						foreach (u; new бцел[0 .. len])
						{
							if (s1[u] != s2[u])
								return s1[u] - s2[u];
						}
					}
					break;
				case 4:
					{
						dchar* s1 = cast(dchar*)ткст;
						dchar* s2 = cast(dchar*)se2.ткст;
						foreach (u; new бцел[0 .. len])
						{
							if (s1[u] != s2[u])
								return s1[u] - s2[u];
						}
					}
					break;
				default:
					assert(0);
            }
        }
        return cast(цел)(len1 - len2);
    }

    override бул isBool(бул результат)
    {
        return результат;
    }

    override бул isLvalue()
    {
        /* ткст literal is rvalue in default, but
		* conversion to reference of static массив is only allowed.
		*/
        return (тип && тип.toBasetype().ty == Tsarray);
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        //printf("StringExp::toLvalue(%s) тип = %s\n", вТкст0(), тип ? тип.вТкст0() : NULL);
        return (тип && тип.toBasetype().ty == Tsarray) ? this : Выражение.toLvalue(sc, e);
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        выведиОшибку("cannot modify ткст literal `%s`", вТкст0());
        return new ErrorExp();
    }

    бцел charAt(uinteger_t i)
    {
        бцел значение;
        switch (sz)
        {
			case 1:
				значение = (cast(сим*)ткст)[cast(т_мера)i];
				break;

			case 2:
				значение = (cast(ushort*)ткст)[cast(т_мера)i];
				break;

			case 4:
				значение = (cast(бцел*)ткст)[cast(т_мера)i];
				break;

			default:
				assert(0);
        }
        return значение;
    }

    /********************************
	* Convert ткст contents to a 0 terminated ткст,
	* allocated by mem.xmalloc().
	*/
    extern (D) ткст вТкст0()
    {
        auto члобайт = len * sz;
        ткст0 s = cast(сим*)mem.xmalloc(члобайт + sz);
        writeTo(s, да);
        return s[0 .. члобайт];
    }

    extern (D) ткст peekString()
    {
        assert(sz == 1);
        return this.ткст[0 .. len];
    }

    extern (D) wткст peekWstring()
    {
        assert(sz == 2);
        return this.wstring[0 .. len];
    }

    extern (D) dткст peekDstring()
    {
        assert(sz == 4);
        return this.dstring[0 .. len];
    }

    /*******************
	* Get a slice of the данные.
	*/
    extern (D) ббайт[] peekData()
    {
        return cast(ббайт[])this.ткст[0 .. len * sz];
    }

    /*******************
	* Borrow a slice of the данные, so the caller can modify
	* it in-place (!)
	*/
    extern (D) ббайт[] borrowData()
    {
        return cast(ббайт[])this.ткст[0 .. len * sz];
    }

    /***********************
	* Set new ткст данные.
	* `this` becomes the new owner of the данные.
	*/
    extern (D) проц setData(ук s, т_мера len, ббайт sz)
    {
        this.ткст = cast(сим*)s;
        this.len = len;
        this.sz = sz;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class TupleExp : Выражение
{
    /* Tuple-field access may need to take out its side effect part.
	* For example:
	*      foo().tupleof
	* is rewritten as:
	*      (ref __tup = foo(); кортеж(__tup.field0, __tup.field1, ...))
	* The declaration of temporary variable __tup will be stored in TupleExp.e0.
	*/
    Выражение e0;

    Выражения* exps;

    this(ref Место место, Выражение e0, Выражения* exps)
    {
        super(место, ТОК2.кортеж, __traits(classInstanceSize, TupleExp));
        //printf("TupleExp(this = %p)\n", this);
        this.e0 = e0;
        this.exps = exps;
    }

    this(ref Место место, Выражения* exps)
    {
        super(место, ТОК2.кортеж, __traits(classInstanceSize, TupleExp));
        //printf("TupleExp(this = %p)\n", this);
        this.exps = exps;
    }

    this(ref Место место, TupleDeclaration tup)
    {
        super(место, ТОК2.кортеж, __traits(classInstanceSize, TupleExp));
        this.exps = new Выражения();

        this.exps.резервируй(tup.objects.dim);
        foreach (o; *tup.objects)
        {
            if (ДСимвол s = getDsymbol(o))
            {
                /* If кортеж element represents a symbol, translate to DsymbolExp
				* to supply implicit 'this' if needed later.
				*/
                Выражение e = new DsymbolExp(место, s);
                this.exps.сунь(e);
            }
            else if (auto eo = o.выражение_ли())
            {
                auto e = eo.копируй();
                e.место = место;    // https://issues.dlang.org/show_bug.cgi?ид=15669
                this.exps.сунь(e);
            }
            else if (auto t = o.тип_ли())
            {
                Выражение e = new TypeExp(место, t);
                this.exps.сунь(e);
            }
            else
            {
                выведиОшибку("`%s` is not an Выражение", o.вТкст0());
            }
        }
    }

    static TupleExp создай(Место место, Выражения* exps)
    {
        return new TupleExp(место, exps);
    }

    override TupleExp toTupleExp()
    {
        return this;
    }

    override Выражение syntaxCopy()
    {
        return new TupleExp(место, e0 ? e0.syntaxCopy() : null, arraySyntaxCopy(exps));
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        if (auto e = o.выражение_ли())
            if (auto te = e.isTupleExp())
            {
                if (exps.dim != te.exps.dim)
                    return нет;
                if (e0 && !e0.равен(te.e0) || !e0 && te.e0)
                    return нет;
                foreach (i, e1; *exps)
                {
                    auto e2 = (*te.exps)[i];
                    if (!e1.равен(e2))
                        return нет;
                }
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
* [ e1, e2, e3, ... ]
*
* http://dlang.org/spec/Выражение.html#array_literals
*/
final class ArrayLiteralExp : Выражение
{
    /** If !is null, elements[] can be sparse and basis is используется for the
	* "default" element значение. In other words, non-null elements[i] overrides
	* this 'basis' значение.
	*/
    Выражение basis;

    Выражения* elements;
    OwnedBy ownedByCtfe = OwnedBy.code;


    this(ref Место место, Тип тип, Выражения* elements)
    {
        super(место, ТОК2.arrayLiteral, __traits(classInstanceSize, ArrayLiteralExp));
        this.тип = тип;
        this.elements = elements;
    }

    this(ref Место место, Тип тип, Выражение e)
    {
        super(место, ТОК2.arrayLiteral, __traits(classInstanceSize, ArrayLiteralExp));
        this.тип = тип;
        elements = new Выражения();
        elements.сунь(e);
    }

    this(ref Место место, Тип тип, Выражение basis, Выражения* elements)
    {
        super(место, ТОК2.arrayLiteral, __traits(classInstanceSize, ArrayLiteralExp));
        this.тип = тип;
        this.basis = basis;
        this.elements = elements;
    }

    static ArrayLiteralExp создай(Место место, Выражения* elements)
    {
        return new ArrayLiteralExp(место, null, elements);
    }

    // Same as создай, but doesn't размести memory.
    static проц emplace(UnionExp* pue, Место место, Выражения* elements)
    {
        emplaceExp!(ArrayLiteralExp)(pue, место, null, elements);
    }

    override Выражение syntaxCopy()
    {
        return new ArrayLiteralExp(место,
								   null,
								   basis ? basis.syntaxCopy() : null,
								   arraySyntaxCopy(elements));
    }

    override бул равен( КорневойОбъект o)
    {
        if (this == o)
            return да;
        auto e = o.выражение_ли();
        if (!e)
            return нет;
        if (auto ae = e.isArrayLiteralExp())
        {
            if (elements.dim != ae.elements.dim)
                return нет;
            if (elements.dim == 0 && !тип.равен(ae.тип))
            {
                return нет;
            }

            foreach (i, e1; *elements)
            {
                auto e2 = (*ae.elements)[i];
                auto e1x = e1 ? e1 : basis;
                auto e2x = e2 ? e2 : ae.basis;

                if (e1x != e2x && (!e1x || !e2x || !e1x.равен(e2x)))
                    return нет;
            }
            return да;
        }
        return нет;
    }

    Выражение getElement(т_мера i)
    {
        return this[i];
    }

    Выражение opIndex(т_мера i)
    {
        auto el = (*elements)[i];
        return el ? el : basis;
    }

    override бул isBool(бул результат)
    {
        т_мера dim = elements ? elements.dim : 0;
        return результат ? (dim != 0) : (dim == 0);
    }

    override StringExp вТкстExp()
    {
        TY telem = тип.nextOf().toBasetype().ty;
        if (telem == Tchar || telem == Twchar || telem == Tdchar ||
            (telem == Tvoid && (!elements || elements.dim == 0)))
        {
            ббайт sz = 1;
            if (telem == Twchar)
                sz = 2;
            else if (telem == Tdchar)
                sz = 4;

            БуфВыв буф;
            if (elements)
            {
                foreach (i; new бцел[0 .. elements.dim])
                {
                    auto ch = this[i];
                    if (ch.op != ТОК2.int64)
                        return null;
                    if (sz == 1)
                        буф.пишиБайт(cast(бцел)ch.toInteger());
                    else if (sz == 2)
                        буф.пишиУорд(cast(бцел)ch.toInteger());
                    else
                        буф.пиши4(cast(бцел)ch.toInteger());
                }
            }
            сим префикс;
            if (sz == 1)
            {
                префикс = 'c';
                буф.пишиБайт(0);
            }
            else if (sz == 2)
            {
                префикс = 'w';
                буф.пишиУорд(0);
            }
            else
            {
                префикс = 'd';
                буф.пиши4(0);
            }

            const т_мера len = буф.length / sz - 1;
            auto se = new StringExp(место, буф.извлекиСрез()[0 .. len * sz], len, sz, префикс);
            se.sz = sz;
            se.тип = тип;
            return se;
        }
        return null;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* [ key0 : value0, key1 : value1, ... ]
*
* http://dlang.org/spec/Выражение.html#associative_array_literals
*/
final class AssocArrayLiteralExp : Выражение
{
    Выражения* keys;
    Выражения* values;

    OwnedBy ownedByCtfe = OwnedBy.code;

    this(ref Место место, Выражения* keys, Выражения* values)
    {
        super(место, ТОК2.assocArrayLiteral, __traits(classInstanceSize, AssocArrayLiteralExp));
        assert(keys.dim == values.dim);
        this.keys = keys;
        this.values = values;
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        auto e = o.выражение_ли();
        if (!e)
            return нет;
        if (auto ae = e.isAssocArrayLiteralExp())
        {
            if (keys.dim != ae.keys.dim)
                return нет;
            т_мера count = 0;
            foreach (i, ключ; *keys)
            {
                foreach (j, akey; *ae.keys)
                {
                    if (ключ.равен(akey))
                    {
                        if (!(*values)[i].равен((*ae.values)[j]))
                            return нет;
                        ++count;
                    }
                }
            }
            return count == keys.dim;
        }
        return нет;
    }

    override Выражение syntaxCopy()
    {
        return new AssocArrayLiteralExp(место, arraySyntaxCopy(keys), arraySyntaxCopy(values));
    }

    override бул isBool(бул результат)
    {
        т_мера dim = keys.dim;
        return результат ? (dim != 0) : (dim == 0);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

const stageScrub             = 0x1;  /// scrubReturnValue is running
const stageSearchPointers    = 0x2;  /// hasNonConstPointers is running
const stageOptimize          = 0x4;  /// optimize is running
const stageApply             = 0x8;  /// apply is running
const stageInlineScan        = 0x10; /// inlineScan is running
const stageToCBuffer         = 0x20; /// toCBuffer is running

/***********************************************************
* sd( e1, e2, e3, ... )
*/
final class StructLiteralExp : Выражение
{
    StructDeclaration sd;   /// which aggregate this is for
    Выражения* elements;  /// parallels sd.fields[] with null entries for fields to skip
    Тип stype;             /// final тип of результат (can be different from sd's тип)

    Symbol* sym;            /// back end symbol to initialize with literal

    /** pointer to the origin instance of the Выражение.
	* once a new Выражение is created, origin is set to 'this'.
	* anytime when an Выражение копируй is created, 'origin' pointer is set to
	* 'origin' pointer значение of the original Выражение.
	*/
    StructLiteralExp origin;

    /// those fields need to prevent a infinite recursion when one field of struct initialized with 'this' pointer.
    StructLiteralExp inlinecopy;

    /** anytime when recursive function is calling, 'stageflags' marks with bit флаг of
	* current stage and unmarks before return from this function.
	* 'inlinecopy' uses similar 'stageflags' and from multiple evaluation 'doInline'
	* (with infinite recursion) of this Выражение.
	*/
    цел stageflags;

    бул useStaticInit;     /// if this is да, use the StructDeclaration's init symbol
    бул isOriginal = нет; /// используется when moving instances to indicate `this is this.origin`
    OwnedBy ownedByCtfe = OwnedBy.code;

    this(ref Место место, StructDeclaration sd, Выражения* elements, Тип stype = null)
    {
        super(место, ТОК2.structLiteral, __traits(classInstanceSize, StructLiteralExp));
        this.sd = sd;
        if (!elements)
            elements = new Выражения();
        this.elements = elements;
        this.stype = stype;
        this.origin = this;
        //printf("StructLiteralExp::StructLiteralExp(%s)\n", вТкст0());
    }

    static StructLiteralExp создай(Место место, StructDeclaration sd, ук elements, Тип stype = null)
    {
        return new StructLiteralExp(место, sd, cast(Выражения*)elements, stype);
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        auto e = o.выражение_ли();
        if (!e)
            return нет;
        if (auto se = e.isStructLiteralExp())
        {
            if (!тип.равен(se.тип))
                return нет;
            if (elements.dim != se.elements.dim)
                return нет;
            foreach (i, e1; *elements)
            {
                auto e2 = (*se.elements)[i];
                if (e1 != e2 && (!e1 || !e2 || !e1.равен(e2)))
                    return нет;
            }
            return да;
        }
        return нет;
    }

    override Выражение syntaxCopy()
    {
        auto exp = new StructLiteralExp(место, sd, arraySyntaxCopy(elements), тип ? тип : stype);
        exp.origin = this;
        return exp;
    }

    /**************************************
	* Gets Выражение at смещение of тип.
	* Возвращает NULL if not found.
	*/
    Выражение getField(Тип тип, бцел смещение)
    {
        //printf("StructLiteralExp::getField(this = %s, тип = %s, смещение = %u)\n",
        //  /*вТкст0()*/"", тип.вТкст0(), смещение);
        Выражение e = null;
        цел i = getFieldIndex(тип, смещение);

        if (i != -1)
        {
            //printf("\ti = %d\n", i);
            if (i >= sd.nonHiddenFields())
                return null;

            assert(i < elements.dim);
            e = (*elements)[i];
            if (e)
            {
                //printf("e = %s, e.тип = %s\n", e.вТкст0(), e.тип.вТкст0());

                /* If тип is a static массив, and e is an инициализатор for that массив,
				* then the field инициализатор should be an массив literal of e.
				*/
                auto tsa = тип.isTypeSArray();
                if (tsa && e.тип.castMod(0) != тип.castMod(0))
                {
                    const length = cast(т_мера)tsa.dim.toInteger();
                    auto z = new Выражения(length);
                    foreach (ref q; *z)
                        q = e.копируй();
                    e = new ArrayLiteralExp(место, тип, z);
                }
                else
                {
                    e = e.копируй();
                    e.тип = тип;
                }
                if (useStaticInit && e.тип.needsNested())
                    if (auto se = e.isStructLiteralExp())
                    {
                        se.useStaticInit = да;
                    }
            }
        }
        return e;
    }

    /************************************
	* Get index of field.
	* Возвращает -1 if not found.
	*/
    цел getFieldIndex(Тип тип, бцел смещение)
    {
        /* Find which field смещение is by looking at the field offsets
		*/
        if (elements.dim)
        {
            foreach (i, v; sd.fields)
            {
                if (смещение == v.смещение && тип.size() == v.тип.size())
                {
                    /* context fields might not be filled. */
                    if (i >= sd.nonHiddenFields())
                        return cast(цел)i;
                    if (auto e = (*elements)[i])
                    {
                        return cast(цел)i;
                    }
                    break;
                }
            }
        }
        return -1;
    }

    override Выражение addDtorHook(Scope* sc)
    {
        /* If struct requires a destructor, rewrite as:
		*    (S tmp = S()),tmp
		* so that the destructor can be hung on tmp.
		*/
        if (sd.dtor && sc.func)
        {
            /* Make an идентификатор for the temporary of the form:
			*   __sl%s%d, where %s is the struct имя
			*/
            const т_мера len = 10;
            сим[len] буф = проц;

            const идент = sd.идент.вТкст;
            const префикс = "__sl";
            const charsToUse = идент.length > len - префикс.length ? len - префикс.length : идент.length;
            буф[0 .. префикс.length] = префикс;
            буф[префикс.length .. префикс.length + charsToUse] = идент[0 .. charsToUse];

            auto tmp = copyToTemp(0, буф, this);
            Выражение ae = new DeclarationExp(место, tmp);
            Выражение e = new CommaExp(место, ae, new VarExp(место, tmp));
            e = e.ВыражениеSemantic(sc);
            return e;
        }
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Mainly just a placeholder
*/
final class TypeExp : Выражение
{
    this(ref Место место, Тип тип)
    {
        super(место, ТОК2.тип, __traits(classInstanceSize, TypeExp));
        //printf("TypeExp::TypeExp(%s)\n", тип.вТкст0());
        this.тип = тип;
    }

    override Выражение syntaxCopy()
    {
        return new TypeExp(место, тип.syntaxCopy());
    }

    override бул checkType()
    {
        выведиОшибку("тип `%s` is not an Выражение", вТкст0());
        return да;
    }

    override бул checkValue()
    {
        выведиОшибку("тип `%s` has no значение", вТкст0());
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Mainly just a placeholder of
*  Package, Module, Nspace, and TemplateInstance (including TemplateMixin)
*
* A template instance that requires IFTI:
*      foo!tiargs(fargs)       // foo!tiargs
* is left until CallExp::semantic() or resolveProperties()
*/
final class ScopeExp : Выражение
{
    ScopeDsymbol sds;

    this(ref Место место, ScopeDsymbol sds)
    {
        super(место, ТОК2.scope_, __traits(classInstanceSize, ScopeExp));
        //printf("ScopeExp::ScopeExp(sds = '%s')\n", sds.вТкст0());
        //static цел count; if (++count == 38) *(сим*)0=0;
        this.sds = sds;
        assert(!sds.isTemplateDeclaration());   // instead, you should use TemplateExp
    }

    override Выражение syntaxCopy()
    {
        return new ScopeExp(место, cast(ScopeDsymbol)sds.syntaxCopy(null));
    }

    override бул checkType()
    {
        if (sds.isPackage())
        {
            выведиОшибку("%s `%s` has no тип", sds.вид(), sds.вТкст0());
            return да;
        }
        if (auto ti = sds.isTemplateInstance())
        {
            //assert(ti.needsTypeInference(sc));
            if (ti.tempdecl &&
                ti.semantictiargsdone &&
                ti.semanticRun == PASS.init)
            {
                выведиОшибку("partial %s `%s` has no тип", sds.вид(), вТкст0());
                return да;
            }
        }
        return нет;
    }

    override бул checkValue()
    {
        выведиОшибку("%s `%s` has no значение", sds.вид(), sds.вТкст0());
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Mainly just a placeholder
*/
final class TemplateExp : Выражение
{
    TemplateDeclaration td;
    FuncDeclaration fd;

    this(ref Место место, TemplateDeclaration td, FuncDeclaration fd = null)
    {
        super(место, ТОК2.template_, __traits(classInstanceSize, TemplateExp));
        //printf("TemplateExp(): %s\n", td.вТкст0());
        this.td = td;
        this.fd = fd;
    }

    override бул isLvalue()
    {
        return fd !is null;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (!fd)
            return Выражение.toLvalue(sc, e);

        assert(sc);
        return symbolToExp(fd, место, sc, да);
    }

    override бул checkType()
    {
        выведиОшибку("%s `%s` has no тип", td.вид(), вТкст0());
        return да;
    }

    override бул checkValue()
    {
        выведиОшибку("%s `%s` has no значение", td.вид(), вТкст0());
        return да;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* thisexp.new(newargs) newtype(arguments)
*/
final class NewExp : Выражение
{
    Выражение thisexp;         // if !=null, 'this' for class being allocated
    Выражения* newargs;       // МассивДРК of Выражение's to call new operator
    Тип newtype;
    Выражения* arguments;     // МассивДРК of Выражение's

    Выражение argprefix;       // Выражение to be evaluated just before arguments[]
    CtorDeclaration member;     // constructor function
    NewDeclaration allocator;   // allocator function
    бул onstack;               // размести on stack
    бул thrownew;              // this NewExp is the Выражение of a ThrowStatement

    this(ref Место место, Выражение thisexp, Выражения* newargs, Тип newtype, Выражения* arguments)
    {
        super(место, ТОК2.new_, __traits(classInstanceSize, NewExp));
        this.thisexp = thisexp;
        this.newargs = newargs;
        this.newtype = newtype;
        this.arguments = arguments;
    }

    static NewExp создай(Место место, Выражение thisexp, Выражения* newargs, Тип newtype, Выражения* arguments)
    {
        return new NewExp(место, thisexp, newargs, newtype, arguments);
    }

    override Выражение syntaxCopy()
    {
        return new NewExp(место,
						  thisexp ? thisexp.syntaxCopy() : null,
						  arraySyntaxCopy(newargs),
						  newtype.syntaxCopy(),
						  arraySyntaxCopy(arguments));
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* thisexp.new(newargs) class baseclasses { } (arguments)
*/
final class NewAnonClassExp : Выражение
{
    Выражение thisexp;     // if !=null, 'this' for class being allocated
    Выражения* newargs;   // МассивДРК of Выражение's to call new operator
    ClassDeclaration cd;    // class being instantiated
    Выражения* arguments; // МассивДРК of Выражение's to call class constructor

    this(ref Место место, Выражение thisexp, Выражения* newargs, ClassDeclaration cd, Выражения* arguments)
    {
        super(место, ТОК2.newAnonymousClass, __traits(classInstanceSize, NewAnonClassExp));
        this.thisexp = thisexp;
        this.newargs = newargs;
        this.cd = cd;
        this.arguments = arguments;
    }

    override Выражение syntaxCopy()
    {
        return new NewAnonClassExp(место, thisexp ? thisexp.syntaxCopy() : null, arraySyntaxCopy(newargs), cast(ClassDeclaration)cd.syntaxCopy(null), arraySyntaxCopy(arguments));
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
class SymbolExp : Выражение
{
    Declaration var;
    бул hasOverloads;
    ДСимвол originalScope; // original scope before inlining

    this(ref Место место, ТОК2 op, цел size, Declaration var, бул hasOverloads)
    {
        super(место, op, size);
        assert(var);
        this.var = var;
        this.hasOverloads = hasOverloads;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Offset from symbol
*/
final class SymOffExp : SymbolExp
{
    dinteger_t смещение;

    this(ref Место место, Declaration var, dinteger_t смещение, бул hasOverloads = да)
    {
        if (auto v = var.isVarDeclaration())
        {
            // FIXME: This error report will never be handled anyone.
            // It should be done before the SymOffExp construction.
            if (v.needThis())
                .выведиОшибку(место, "need `this` for address of `%s`", v.вТкст0());
            hasOverloads = нет;
        }
        super(место, ТОК2.symbolOffset, __traits(classInstanceSize, SymOffExp), var, hasOverloads);
        this.смещение = смещение;
    }

    override бул isBool(бул результат)
    {
        return результат ? да : нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Variable
*/
final class VarExp : SymbolExp
{
    бул delegateWasExtracted;
    this(ref Место место, Declaration var, бул hasOverloads = да)
    {
        if (var.isVarDeclaration())
            hasOverloads = нет;

        super(место, ТОК2.variable, __traits(classInstanceSize, VarExp), var, hasOverloads);
        //printf("VarExp(this = %p, '%s', место = %s)\n", this, var.вТкст0(), место.вТкст0());
        //if (strcmp(var.идент.вТкст0(), "func") == 0) assert(0);
        this.тип = var.тип;
    }

    static VarExp создай(Место место, Declaration var, бул hasOverloads = да)
    {
        return new VarExp(место, var, hasOverloads);
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        if (auto ne = o.выражение_ли().isVarExp())
        {
            if (тип.toHeadMutable().равен(ne.тип.toHeadMutable()) && var == ne.var)
            {
                return да;
            }
        }
        return нет;
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        //printf("VarExp::checkModifiable %s", вТкст0());
        assert(тип);
        return var.checkModify(место, sc, null, флаг);
    }

    override бул isLvalue()
    {
        if (var.класс_хранения & (STC.lazy_ | STC.rvalue | STC.manifest))
            return нет;
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (var.класс_хранения & STC.manifest)
        {
            выведиОшибку("manifest constant `%s` cannot be modified", var.вТкст0());
            return new ErrorExp();
        }
        if (var.класс_хранения & STC.lazy_ && !delegateWasExtracted)
        {
            выведиОшибку("lazy variable `%s` cannot be modified", var.вТкст0());
            return new ErrorExp();
        }
        if (var.идент == Id.ctfe)
        {
            выведиОшибку("cannot modify compiler-generated variable `__ctfe`");
            return new ErrorExp();
        }
        if (var.идент == Id.dollar) // https://issues.dlang.org/show_bug.cgi?ид=13574
        {
            выведиОшибку("cannot modify operator `$`");
            return new ErrorExp();
        }
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        //printf("VarExp::modifiableLvalue('%s')\n", var.вТкст0());
        if (var.класс_хранения & STC.manifest)
        {
            выведиОшибку("cannot modify manifest constant `%s`", вТкст0());
            return new ErrorExp();
        }
        // See if this Выражение is a modifiable lvalue (i.e. not const)
        return Выражение.modifiableLvalue(sc, e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    override Выражение syntaxCopy()
    {
        auto ret = super.syntaxCopy();
        return ret;
    }
}

/***********************************************************
* Overload Set
*/
final class OverExp : Выражение
{
    OverloadSet vars;

    this(ref Место место, OverloadSet s)
    {
        super(место, ТОК2.overloadSet, __traits(classInstanceSize, OverExp));
        //printf("OverExp(this = %p, '%s')\n", this, var.вТкст0());
        vars = s;
        тип = Тип.tvoid;
    }

    override бул isLvalue()
    {
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Function/Delegate literal
*/

final class FuncExp : Выражение
{
    FuncLiteralDeclaration fd;
    TemplateDeclaration td;
    ТОК2 tok;

    this(ref Место место, ДСимвол s)
    {
        super(место, ТОК2.function_, __traits(classInstanceSize, FuncExp));
        this.td = s.isTemplateDeclaration();
        this.fd = s.isFuncLiteralDeclaration();
        if (td)
        {
            assert(td.literal);
            assert(td.члены && td.члены.dim == 1);
            fd = (*td.члены)[0].isFuncLiteralDeclaration();
        }
        tok = fd.tok; // save original вид of function/delegate/(infer)
        assert(fd.fbody);
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        auto e = o.выражение_ли();
        if (!e)
            return нет;
        if (auto fe = e.isFuncExp())
        {
            return fd == fe.fd;
        }
        return нет;
    }

    extern (D) проц genIdent(Scope* sc)
    {
        if (fd.идент == Id.empty)
        {
            ткст s;
            if (fd.fes)
                s = "__foreachbody";
            else if (fd.tok == ТОК2.reserved)
                s = "__lambda";
            else if (fd.tok == ТОК2.delegate_)
                s = "__dgliteral";
            else
                s = "__funcliteral";

            DsymbolTable symtab;
            if (FuncDeclaration func = sc.родитель.isFuncDeclaration())
            {
                if (func.localsymtab is null)
                {
                    // Inside template constraint, symtab is not set yet.
                    // Initialize it lazily.
                    func.localsymtab = new DsymbolTable();
                }
                symtab = func.localsymtab;
            }
            else
            {
                ScopeDsymbol sds = sc.родитель.isScopeDsymbol();
                if (!sds.symtab)
                {
                    // Inside template constraint, symtab may not be set yet.
                    // Initialize it lazily.
                    assert(sds.isTemplateInstance());
                    sds.symtab = new DsymbolTable();
                }
                symtab = sds.symtab;
            }
            assert(symtab);
            Идентификатор2 ид = Идентификатор2.генерируйИд(s, symtab.len() + 1);
            fd.идент = ид;
            if (td)
                td.идент = ид;
            symtab.вставь(td ? cast(ДСимвол)td : cast(ДСимвол)fd);
        }
    }

    override Выражение syntaxCopy()
    {
        if (td)
            return new FuncExp(место, td.syntaxCopy(null));
        else if (fd.semanticRun == PASS.init)
            return new FuncExp(место, fd.syntaxCopy(null));
        else // https://issues.dlang.org/show_bug.cgi?ид=13481
			// Prevent multiple semantic analysis of lambda body.
            return new FuncExp(место, fd);
    }

    extern (D) MATCH matchType(Тип to, Scope* sc, FuncExp* pрезультат, цел флаг = 0)
    {

        static MATCH cannotInfer(Выражение e, Тип to, цел флаг)
        {
            if (!флаг)
                e.выведиОшибку("cannot infer параметр types from `%s`", to.вТкст0());
            return MATCH.nomatch;
        }

        //printf("FuncExp::matchType('%s'), to=%s\n", тип ? тип.вТкст0() : "null", to.вТкст0());
        if (pрезультат)
            *pрезультат = null;

        TypeFunction tof = null;
        if (to.ty == Tdelegate)
        {
            if (tok == ТОК2.function_)
            {
                if (!флаг)
                    выведиОшибку("cannot match function literal to delegate тип `%s`", to.вТкст0());
                return MATCH.nomatch;
            }
            tof = cast(TypeFunction)to.nextOf();
        }
        else if (to.ty == Tpointer && (tof = to.nextOf().isTypeFunction()) !is null)
        {
            if (tok == ТОК2.delegate_)
            {
                if (!флаг)
                    выведиОшибку("cannot match delegate literal to function pointer тип `%s`", to.вТкст0());
                return MATCH.nomatch;
            }
        }

        if (td)
        {
            if (!tof)
            {
                return cannotInfer(this, to, флаг);
            }

            // Параметр2 types inference from 'tof'
            assert(td._scope);
            TypeFunction tf = fd.тип.isTypeFunction();
            //printf("\ttof = %s\n", tof.вТкст0());
            //printf("\ttf  = %s\n", tf.вТкст0());
            т_мера dim = tf.parameterList.length;

            if (tof.parameterList.length != dim || tof.parameterList.varargs != tf.parameterList.varargs)
                return cannotInfer(this, to, флаг);

            auto tiargs = new Объекты();
            tiargs.резервируй(td.parameters.dim);

            foreach (tp; *td.parameters)
            {
                т_мера u = 0;
                for (; u < dim; u++)
                {
                    Параметр2 p = tf.parameterList[u];
                    if (auto ti = p.тип.isTypeIdentifier())
                        if (ti && ti.идент == tp.идент)
                        {
                            break;
                        }
                }
                assert(u < dim);
                Параметр2 pto = tof.parameterList[u];
                Тип t = pto.тип;
                if (t.ty == Terror)
                    return cannotInfer(this, to, флаг);
                tiargs.сунь(t);
            }

            // Set target of return тип inference
            if (!tf.следщ && tof.следщ)
                fd.treq = to;

            auto ti = new TemplateInstance(место, td, tiargs);
            Выражение ex = (new ScopeExp(место, ti)).ВыражениеSemantic(td._scope);

            // Reset inference target for the later re-semantic
            fd.treq = null;

            if (ex.op == ТОК2.error)
                return MATCH.nomatch;
            if (auto ef = ex.isFuncExp())
                return ef.matchType(to, sc, pрезультат, флаг);
            else
                return cannotInfer(this, to, флаг);
        }

        if (!tof || !tof.следщ)
            return MATCH.nomatch;

        assert(тип && тип != Тип.tvoid);
        if (fd.тип.ty == Terror)
            return MATCH.nomatch;
        auto tfx = fd.тип.isTypeFunction();
        бул convertMatch = (тип.ty != to.ty);

        if (fd.inferRetType && tfx.следщ.implicitConvTo(tof.следщ) == MATCH.convert)
        {
            /* If return тип is inferred and covariant return,
			* tweak return statements to required return тип.
			*
			* interface I {}
			* class C : Object, I{}
			*
			* I delegate() dg = delegate() { return new class C(); }
			*/
            convertMatch = да;

            auto tfy = new TypeFunction(tfx.parameterList, tof.следщ,
										tfx.компонаж, STC.undefined_);
            tfy.mod = tfx.mod;
            tfy.isnothrow = tfx.isnothrow;
            tfy.isnogc = tfx.isnogc;
            tfy.purity = tfx.purity;
            tfy.isproperty = tfx.isproperty;
            tfy.isref = tfx.isref;
            tfy.iswild = tfx.iswild;
            tfy.deco = tfy.merge().deco;

            tfx = tfy;
        }
        Тип tx;
        if (tok == ТОК2.delegate_ ||
            tok == ТОК2.reserved && (тип.ty == Tdelegate || тип.ty == Tpointer && to.ty == Tdelegate))
        {
            // Allow conversion from implicit function pointer to delegate
            tx = new TypeDelegate(tfx);
            tx.deco = tx.merge().deco;
        }
        else
        {
            assert(tok == ТОК2.function_ || tok == ТОК2.reserved && тип.ty == Tpointer);
            tx = tfx.pointerTo();
        }
        //printf("\ttx = %s, to = %s\n", tx.вТкст0(), to.вТкст0());

        MATCH m = tx.implicitConvTo(to);
        if (m > MATCH.nomatch)
        {
            // MATCH.exact:      exact тип match
            // MATCH.constant:      covairiant тип match (eg. attributes difference)
            // MATCH.convert:    context conversion
            m = convertMatch ? MATCH.convert : tx.равен(to) ? MATCH.exact : MATCH.constant;

            if (pрезультат)
            {
                (*pрезультат) = cast(FuncExp)копируй();
                (*pрезультат).тип = to;

                // https://issues.dlang.org/show_bug.cgi?ид=12508
                // Tweak function body for covariant returns.
                (*pрезультат).fd.modifyReturns(sc, tof.следщ);
            }
        }
        else if (!флаг)
        {
            auto ts = toAutoQualChars(tx, to);
            выведиОшибку("cannot implicitly convert Выражение `%s` of тип `%s` to `%s`",
						 вТкст0(), ts[0], ts[1]);
        }
        return m;
    }

    override ткст0 вТкст0()
    {
        return fd.вТкст0();
    }

    override бул checkType()
    {
        if (td)
        {
            выведиОшибку("template lambda has no тип");
            return да;
        }
        return нет;
    }

    override бул checkValue()
    {
        if (td)
        {
            выведиОшибку("template lambda has no значение");
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
* Declaration of a symbol
*
* D grammar allows declarations only as statements. However in AST representation
* it can be part of any Выражение. This is используется, for example, during internal
* syntax re-writes to inject hidden symbols.
*/
final class DeclarationExp : Выражение
{
    ДСимвол declaration;

    this(ref Место место, ДСимвол declaration)
    {
        super(место, ТОК2.declaration, __traits(classInstanceSize, DeclarationExp));
        this.declaration = declaration;
    }

    override Выражение syntaxCopy()
    {
        return new DeclarationExp(место, declaration.syntaxCopy(null));
    }

    override бул hasCode()
    {
        if (auto vd = declaration.isVarDeclaration())
        {
            return !(vd.класс_хранения & (STC.manifest | STC.static_));
        }
        return нет;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* typeid(цел)
*/
final class TypeidExp : Выражение
{
    КорневойОбъект obj;

    this(ref Место место, КорневойОбъект o)
    {
        super(место, ТОК2.typeid_, __traits(classInstanceSize, TypeidExp));
        this.obj = o;
    }

    override Выражение syntaxCopy()
    {
        return new TypeidExp(место, objectSyntaxCopy(obj));
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* __traits(идентификатор, args...)
*/
final class TraitsExp : Выражение
{
    Идентификатор2 идент;
    Объекты* args;

    this(ref Место место, Идентификатор2 идент, Объекты* args)
    {
        super(место, ТОК2.traits, __traits(classInstanceSize, TraitsExp));
        this.идент = идент;
        this.args = args;
    }

    override Выражение syntaxCopy()
    {
        return new TraitsExp(место, идент, TemplateInstance.arraySyntaxCopy(args));
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class HaltExp : Выражение
{
    this(ref Место место)
    {
        super(место, ТОК2.halt, __traits(classInstanceSize, HaltExp));
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* is(targ ид tok tspec)
* is(targ ид == tok2)
*/
final class IsExp : Выражение
{
    Тип targ;
    Идентификатор2 ид;      // can be null
    Тип tspec;         // can be null
    ПараметрыШаблона* parameters;
    ТОК2 tok;            // ':' or '=='
    ТОК2 tok2;           // 'struct', 'union', etc.

    this(ref Место место, Тип targ, Идентификатор2 ид, ТОК2 tok, Тип tspec, ТОК2 tok2, ПараметрыШаблона* parameters)
    {
        super(место, ТОК2.is_, __traits(classInstanceSize, IsExp));
        this.targ = targ;
        this.ид = ид;
        this.tok = tok;
        this.tspec = tspec;
        this.tok2 = tok2;
        this.parameters = parameters;
    }

    override Выражение syntaxCopy()
    {
        // This section is identical to that in TemplateDeclaration::syntaxCopy()
        ПараметрыШаблона* p = null;
        if (parameters)
        {
            p = new ПараметрыШаблона(parameters.dim);
            foreach (i, el; *parameters)
                (*p)[i] = el.syntaxCopy();
        }
        return new IsExp(место, targ.syntaxCopy(), ид, tok, tspec ? tspec.syntaxCopy() : null, tok2, p);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
abstract class UnaExp : Выражение
{
    Выражение e1;
    Тип att1;      // Save alias this тип to detect recursion

    this(ref Место место, ТОК2 op, цел size, Выражение e1)
    {
        super(место, op, size);
        this.e1 = e1;
    }

    override Выражение syntaxCopy()
    {
        UnaExp e = cast(UnaExp)копируй();
        e.тип = null;
        e.e1 = e.e1.syntaxCopy();
        return e;
    }

    /********************************
	* The тип for a unary Выражение is incompatible.
	* Print error message.
	* Возвращает:
	*  ErrorExp
	*/
    final Выражение incompatibleTypes()
    {
        if (e1.тип.toBasetype() == Тип.terror)
            return e1;

        if (e1.op == ТОК2.тип)
        {
            выведиОшибку("incompatible тип for `%s(%s)`: cannot use `%s` with types", Сема2.вТкст0(op), e1.вТкст0(), Сема2.вТкст0(op));
        }
        else
        {
            выведиОшибку("incompatible тип for `%s(%s)`: `%s`", Сема2.вТкст0(op), e1.вТкст0(), e1.тип.вТкст0());
        }
        return new ErrorExp();
    }

    /*********************
	* Mark the operand as will never be dereferenced,
	* which is useful info for  checks.
	* Do before semantic() on operands rewrites them.
	*/
    final проц setNoderefOperand()
    {
        if (auto edi = e1.isDotIdExp())
            edi.noderef = да;

    }

    override final Выражение resolveLoc(ref Место место, Scope* sc)
    {
        e1 = e1.resolveLoc(место, sc);
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

alias  UnionExp function(ref Место место, Тип, Выражение, Выражение) fp_t;
alias  бул function(ref Место место, ТОК2, Выражение, Выражение) fp2_t;

/***********************************************************
*/
abstract class BinExp : Выражение
{
    Выражение e1;
    Выражение e2;
    Тип att1;      // Save alias this тип to detect recursion
    Тип att2;      // Save alias this тип to detect recursion

    this(ref Место место, ТОК2 op, цел size, Выражение e1, Выражение e2)
    {
        super(место, op, size);
        this.e1 = e1;
        this.e2 = e2;
    }

    override Выражение syntaxCopy()
    {
        BinExp e = cast(BinExp)копируй();
        e.тип = null;
        e.e1 = e.e1.syntaxCopy();
        e.e2 = e.e2.syntaxCopy();
        return e;
    }

    /********************************
	* The types for a binary Выражение are incompatible.
	* Print error message.
	* Возвращает:
	*  ErrorExp
	*/
    final Выражение incompatibleTypes()
    {
        if (e1.тип.toBasetype() == Тип.terror)
            return e1;
        if (e2.тип.toBasetype() == Тип.terror)
            return e2;

        // CondExp uses 'a ? b : c' but we're comparing 'b : c'
        ТОК2 thisOp = (op == ТОК2.question) ? ТОК2.colon : op;
        if (e1.op == ТОК2.тип || e2.op == ТОК2.тип)
        {
            выведиОшибку("incompatible types for `(%s) %s (%s)`: cannot use `%s` with types",
						 e1.вТкст0(), Сема2.вТкст0(thisOp), e2.вТкст0(), Сема2.вТкст0(op));
        }
        else if (e1.тип.равен(e2.тип))
        {
            выведиОшибку("incompatible types for `(%s) %s (%s)`: both operands are of тип `%s`",
						 e1.вТкст0(), Сема2.вТкст0(thisOp), e2.вТкст0(), e1.тип.вТкст0());
        }
        else
        {
            auto ts = toAutoQualChars(e1.тип, e2.тип);
            выведиОшибку("incompatible types for `(%s) %s (%s)`: `%s` and `%s`",
						 e1.вТкст0(), Сема2.вТкст0(thisOp), e2.вТкст0(), ts[0], ts[1]);
        }
        return new ErrorExp();
    }

    extern (D) final Выражение checkOpAssignTypes(Scope* sc)
    {
        // At that point t1 and t2 are the merged types. тип is the original тип of the lhs.
        Тип t1 = e1.тип;
        Тип t2 = e2.тип;

        // T opAssign floating yields a floating. Prevent truncating conversions (float to цел).
        // See issue 3841.
        // Should we also prevent double to float (тип.isfloating() && тип.size() < t2.size()) ?
        if (op == ТОК2.addAssign || op == ТОК2.minAssign ||
            op == ТОК2.mulAssign || op == ТОК2.divAssign || op == ТОК2.modAssign ||
            op == ТОК2.powAssign)
        {
            if ((тип.isintegral() && t2.isfloating()))
            {
                warning("`%s %s %s` is performing truncating conversion", тип.вТкст0(), Сема2.вТкст0(op), t2.вТкст0());
            }
        }

        // generate an error if this is a nonsensical *=,/=, or %=, eg real *= imaginary
        if (op == ТОК2.mulAssign || op == ТОК2.divAssign || op == ТОК2.modAssign)
        {
            // Any multiplication by an imaginary or complex number yields a complex результат.
            // r *= c, i*=c, r*=i, i*=i are all forbidden operations.
            ткст0 opstr = Сема2.вТкст0(op);
            if (t1.isreal() && t2.iscomplex())
            {
                выведиОшибку("`%s %s %s` is undefined. Did you mean `%s %s %s.re`?", t1.вТкст0(), opstr, t2.вТкст0(), t1.вТкст0(), opstr, t2.вТкст0());
                return new ErrorExp();
            }
            else if (t1.isimaginary() && t2.iscomplex())
            {
                выведиОшибку("`%s %s %s` is undefined. Did you mean `%s %s %s.im`?", t1.вТкст0(), opstr, t2.вТкст0(), t1.вТкст0(), opstr, t2.вТкст0());
                return new ErrorExp();
            }
            else if ((t1.isreal() || t1.isimaginary()) && t2.isimaginary())
            {
                выведиОшибку("`%s %s %s` is an undefined operation", t1.вТкст0(), opstr, t2.вТкст0());
                return new ErrorExp();
            }
        }

        // generate an error if this is a nonsensical += or -=, eg real += imaginary
        if (op == ТОК2.addAssign || op == ТОК2.minAssign)
        {
            // Addition or subtraction of a real and an imaginary is a complex результат.
            // Thus, r+=i, r+=c, i+=r, i+=c are all forbidden operations.
            if ((t1.isreal() && (t2.isimaginary() || t2.iscomplex())) || (t1.isimaginary() && (t2.isreal() || t2.iscomplex())))
            {
                выведиОшибку("`%s %s %s` is undefined (результат is complex)", t1.вТкст0(), Сема2.вТкст0(op), t2.вТкст0());
                return new ErrorExp();
            }
            if (тип.isreal() || тип.isimaginary())
            {
                assert(глоб2.errors || t2.isfloating());
                e2 = e2.castTo(sc, t1);
            }
        }
        if (op == ТОК2.mulAssign)
        {
            if (t2.isfloating())
            {
                if (t1.isreal())
                {
                    if (t2.isimaginary() || t2.iscomplex())
                    {
                        e2 = e2.castTo(sc, t1);
                    }
                }
                else if (t1.isimaginary())
                {
                    if (t2.isimaginary() || t2.iscomplex())
                    {
                        switch (t1.ty)
                        {
							case Timaginary32:
								t2 = Тип.tfloat32;
								break;

							case Timaginary64:
								t2 = Тип.tfloat64;
								break;

							case Timaginary80:
								t2 = Тип.tfloat80;
								break;

							default:
								assert(0);
                        }
                        e2 = e2.castTo(sc, t2);
                    }
                }
            }
        }
        else if (op == ТОК2.divAssign)
        {
            if (t2.isimaginary())
            {
                if (t1.isreal())
                {
                    // x/iv = i(-x/v)
                    // Therefore, the результат is 0
                    e2 = new CommaExp(место, e2, new RealExp(место, CTFloat.нуль, t1));
                    e2.тип = t1;
                    Выражение e = new AssignExp(место, e1, e2);
                    e.тип = t1;
                    return e;
                }
                else if (t1.isimaginary())
                {
                    Тип t3;
                    switch (t1.ty)
                    {
						case Timaginary32:
							t3 = Тип.tfloat32;
							break;

						case Timaginary64:
							t3 = Тип.tfloat64;
							break;

						case Timaginary80:
							t3 = Тип.tfloat80;
							break;

						default:
							assert(0);
                    }
                    e2 = e2.castTo(sc, t3);
                    Выражение e = new AssignExp(место, e1, e2);
                    e.тип = t1;
                    return e;
                }
            }
        }
        else if (op == ТОК2.modAssign)
        {
            if (t2.iscomplex())
            {
                выведиОшибку("cannot perform modulo complex arithmetic");
                return new ErrorExp();
            }
        }
        return this;
    }

    extern (D) final бул checkIntegralBin()
    {
        бул r1 = e1.checkIntegral();
        бул r2 = e2.checkIntegral();
        return (r1 || r2);
    }

    extern (D) final бул checkArithmeticBin()
    {
        бул r1 = e1.checkArithmetic();
        бул r2 = e2.checkArithmetic();
        return (r1 || r2);
    }

    extern (D) final бул checkSharedAccessBin(Scope* sc)
    {
        const r1 = e1.checkSharedAccess(sc);
        const r2 = e2.checkSharedAccess(sc);
        return (r1 || r2);
    }

    /*********************
	* Mark the operands as will never be dereferenced,
	* which is useful info for  checks.
	* Do before semantic() on operands rewrites them.
	*/
    final проц setNoderefOperands()
    {
        if (auto edi = e1.isDotIdExp())
            edi.noderef = да;
        if (auto edi = e2.isDotIdExp())
            edi.noderef = да;

    }

    final Выражение reorderSettingAAElem(Scope* sc)
    {
        BinExp be = this;

        auto ie = be.e1.isIndexExp();
        if (!ie)
            return be;
        if (ie.e1.тип.toBasetype().ty != Taarray)
            return be;

        /* Fix evaluation order of setting AA element
		* https://issues.dlang.org/show_bug.cgi?ид=3825
		* Rewrite:
		*     aa[k1][k2][k3] op= val;
		* as:
		*     auto ref __aatmp = aa;
		*     auto ref __aakey3 = k1, __aakey2 = k2, __aakey1 = k3;
		*     auto ref __aaval = val;
		*     __aatmp[__aakey3][__aakey2][__aakey1] op= __aaval;  // assignment
		*/

        Выражение e0;
        while (1)
        {
            Выражение de;
            ie.e2 = extractSideEffect(sc, "__aakey", de, ie.e2);
            e0 = Выражение.combine(de, e0);

            auto ie1 = ie.e1.isIndexExp();
            if (!ie1 ||
                ie1.e1.тип.toBasetype().ty != Taarray)
            {
                break;
            }
            ie = ie1;
        }
        assert(ie.e1.тип.toBasetype().ty == Taarray);

        Выражение de;
        ie.e1 = extractSideEffect(sc, "__aatmp", de, ie.e1);
        e0 = Выражение.combine(de, e0);

        be.e2 = extractSideEffect(sc, "__aaval", e0, be.e2, да);

        //printf("-e0 = %s, be = %s\n", e0.вТкст0(), be.вТкст0());
        return Выражение.combine(e0, be);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
class BinAssignExp : BinExp
{
    this(ref Место место, ТОК2 op, цел size, Выражение e1, Выражение e2)
    {
        super(место, op, size, e1, e2);
    }

    override final бул isLvalue()
    {
        return да;
    }

    override final Выражение toLvalue(Scope* sc, Выражение ex)
    {
        // Lvalue-ness will be handled in glue layer.
        return this;
    }

    override final Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        // should check e1.checkModifiable() ?
        return toLvalue(sc, this);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* https://dlang.org/spec/Выражение.html#mixin_Выражениеs
*/
final class CompileExp : Выражение
{
    Выражения* exps;

    this(ref Место место, Выражения* exps)
    {
        super(место, ТОК2.mixin_, __traits(classInstanceSize, CompileExp));
        this.exps = exps;
    }

    override Выражение syntaxCopy()
    {
        return new CompileExp(место, arraySyntaxCopy(exps));
    }

    override бул равен(КорневойОбъект o)
    {
        if (this == o)
            return да;
        auto e = o.выражение_ли();
        if (!e)
            return нет;
        if (auto ce = e.isCompileExp())
        {
            if (exps.dim != ce.exps.dim)
                return нет;
            foreach (i, e1; *exps)
            {
                auto e2 = (*ce.exps)[i];
                if (e1 != e2 && (!e1 || !e2 || !e1.равен(e2)))
                    return нет;
            }
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
*/
final class ImportExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.import_, __traits(classInstanceSize, ImportExp), e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* https://dlang.org/spec/Выражение.html#assert_Выражениеs
*/
final class AssertExp : UnaExp
{
    Выражение msg;

    this(ref Место место, Выражение e, Выражение msg = null)
    {
        super(место, ТОК2.assert_, __traits(classInstanceSize, AssertExp), e);
        this.msg = msg;
    }

    override Выражение syntaxCopy()
    {
        return new AssertExp(место, e1.syntaxCopy(), msg ? msg.syntaxCopy() : null);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DotIdExp : UnaExp
{
    Идентификатор2 идент;
    бул noderef;       // да if the результат of the Выражение will never be dereferenced
    бул wantsym;       // do not replace Symbol with its инициализатор during semantic()

    this(ref Место место, Выражение e, Идентификатор2 идент)
    {
        super(место, ТОК2.dotIdentifier, __traits(classInstanceSize, DotIdExp), e);
        this.идент = идент;
    }

    static DotIdExp создай(Место место, Выражение e, Идентификатор2 идент)
    {
        return new DotIdExp(место, e, идент);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Mainly just a placeholder
*/
final class DotTemplateExp : UnaExp
{
    TemplateDeclaration td;

    this(ref Место место, Выражение e, TemplateDeclaration td)
    {
        super(место, ТОК2.dotTemplateDeclaration, __traits(classInstanceSize, DotTemplateExp), e);
        this.td = td;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DotVarExp : UnaExp
{
    Declaration var;
    бул hasOverloads;

    this(ref Место место, Выражение e, Declaration var, бул hasOverloads = да)
    {
        if (var.isVarDeclaration())
            hasOverloads = нет;

        super(место, ТОК2.dotVariable, __traits(classInstanceSize, DotVarExp), e);
        //printf("DotVarExp()\n");
        this.var = var;
        this.hasOverloads = hasOverloads;
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        //printf("DotVarExp::checkModifiable %s %s\n", вТкст0(), тип.вТкст0());
        if (checkUnsafeAccess(sc, this, нет, !флаг))
            return Modifiable.initialization;

        if (e1.op == ТОК2.this_)
            return var.checkModify(место, sc, e1, флаг);

        /* https://issues.dlang.org/show_bug.cgi?ид=12764
		* If inside a constructor and an Выражение of тип `this.field.var`
		* is encountered, where `field` is a struct declaration with
		* default construction disabled, we must make sure that
		* assigning to `var` does not imply that `field` was initialized
		*/
        if (sc.func && sc.func.isCtorDeclaration())
        {
            // if inside a constructor scope and e1 of this DotVarExp
            // is a DotVarExp, then check if e1.e1 is a `this` идентификатор
            if (auto dve = e1.isDotVarExp())
            {
                if (dve.e1.op == ТОК2.this_)
                {
                    scope v = dve.var.isVarDeclaration();
                    /* if v is a struct member field with no инициализатор, no default construction
					* and v wasn't intialized before
					*/
                    if (v && v.isField() && !v._иниц && !v.ctorinit)
                    {
                        if (auto ts = v.тип.isTypeStruct())
                        {
                            if (ts.sym.noDefaultCtor)
                            {
                                /* checkModify will consider that this is an initialization
								* of v while it is actually an assignment of a field of v
								*/
                                scope modifyLevel = v.checkModify(место, sc, dve.e1, флаг);
                                // reflect that assigning a field of v is not initialization of v
                                v.ctorinit = нет;
                                if (modifyLevel == Modifiable.initialization)
                                    return Modifiable.yes;
                                return modifyLevel;
                            }
                        }
                    }
                }
            }
        }

        //printf("\te1 = %s\n", e1.вТкст0());
        return e1.checkModifiable(sc, флаг);
    }

    override бул isLvalue()
    {
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        //printf("DotVarExp::toLvalue(%s)\n", вТкст0());
        if (e1.op == ТОК2.this_ && sc.ctorflow.fieldinit.length && !(sc.ctorflow.callSuper & CSX.any_ctor))
        {
            if (VarDeclaration vd = var.isVarDeclaration())
            {
                auto ad = vd.isMember2();
                if (ad && ad.fields.dim == sc.ctorflow.fieldinit.length)
                {
                    foreach (i, f; ad.fields)
                    {
                        if (f == vd)
                        {
                            if (!(sc.ctorflow.fieldinit[i].csx & CSX.this_ctor))
                            {
                                /* If the address of vd is taken, assume it is thereby initialized
								* https://issues.dlang.org/show_bug.cgi?ид=15869
								*/
                                modifyFieldVar(место, sc, vd, e1);
                            }
                            break;
                        }
                    }
                }
            }
        }
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        version (none)
        {
            printf("DotVarExp::modifiableLvalue(%s)\n", вТкст0());
            printf("e1.тип = %s\n", e1.тип.вТкст0());
            printf("var.тип = %s\n", var.тип.вТкст0());
        }

        return Выражение.modifiableLvalue(sc, e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* foo.bar!(args)
*/
final class DotTemplateInstanceExp : UnaExp
{
    TemplateInstance ti;

    this(ref Место место, Выражение e, Идентификатор2 имя, Объекты* tiargs)
    {
        super(место, ТОК2.dotTemplateInstance, __traits(classInstanceSize, DotTemplateInstanceExp), e);
        //printf("DotTemplateInstanceExp()\n");
        this.ti = new TemplateInstance(место, имя, tiargs);
    }

    this(ref Место место, Выражение e, TemplateInstance ti)
    {
        super(место, ТОК2.dotTemplateInstance, __traits(classInstanceSize, DotTemplateInstanceExp), e);
        this.ti = ti;
    }

    override Выражение syntaxCopy()
    {
        return new DotTemplateInstanceExp(место, e1.syntaxCopy(), ti.имя, TemplateInstance.arraySyntaxCopy(ti.tiargs));
    }

    бул findTempDecl(Scope* sc)
    {
        static if (LOGSEMANTIC)
        {
            printf("DotTemplateInstanceExp::findTempDecl('%s')\n", вТкст0());
        }
        if (ti.tempdecl)
            return да;

        Выражение e = new DotIdExp(место, e1, ti.имя);
        e = e.ВыражениеSemantic(sc);
        if (e.op == ТОК2.dot)
            e = (cast(DotExp)e).e2;

        ДСимвол s = null;
        switch (e.op)
        {
			case ТОК2.overloadSet:
				s = (cast(OverExp)e).vars;
				break;

			case ТОК2.dotTemplateDeclaration:
				s = (cast(DotTemplateExp)e).td;
				break;

			case ТОК2.scope_:
				s = (cast(ScopeExp)e).sds;
				break;

			case ТОК2.dotVariable:
				s = (cast(DotVarExp)e).var;
				break;

			case ТОК2.variable:
				s = (cast(VarExp)e).var;
				break;

			default:
				return нет;
        }
        return ti.updateTempDecl(sc, s);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DelegateExp : UnaExp
{
    FuncDeclaration func;
    бул hasOverloads;
    VarDeclaration vthis2;  // container for multi-context

    this(ref Место место, Выражение e, FuncDeclaration f, бул hasOverloads = да, VarDeclaration vthis2 = null)
    {
        super(место, ТОК2.delegate_, __traits(classInstanceSize, DelegateExp), e);
        this.func = f;
        this.hasOverloads = hasOverloads;
        this.vthis2 = vthis2;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DotTypeExp : UnaExp
{
    ДСимвол sym;        // symbol that represents a тип

    this(ref Место место, Выражение e, ДСимвол s)
    {
        super(место, ТОК2.dotType, __traits(classInstanceSize, DotTypeExp), e);
        this.sym = s;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class CallExp : UnaExp
{
    Выражения* arguments; // function arguments
    FuncDeclaration f;      // symbol to call
    бул directcall;        // да if a virtual call is devirtualized
    VarDeclaration vthis2;  // container for multi-context

    this(ref Место место, Выражение e, Выражения* exps)
    {
        super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
        this.arguments = exps;
    }

    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
    }

    this(ref Место место, Выражение e, Выражение earg1)
    {
        super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
        this.arguments = new Выражения();
        if (earg1)
            this.arguments.сунь(earg1);
    }

    this(ref Место место, Выражение e, Выражение earg1, Выражение earg2)
    {
        super(место, ТОК2.call, __traits(classInstanceSize, CallExp), e);
        auto arguments = new Выражения(2);
        (*arguments)[0] = earg1;
        (*arguments)[1] = earg2;
        this.arguments = arguments;
    }

    /***********************************************************
    * Instatiates a new function call Выражение
    * Параметры:
    *       место   = location
    *       fd    = the declaration of the function to call
    *       earg1 = the function argument
    */
    extern(D) this(ref Место место, FuncDeclaration fd, Выражение earg1)
    {
        this(место, new VarExp(место, fd, нет), earg1);
        this.f = fd;
    }

    static CallExp создай(Место место, Выражение e, Выражения* exps)
    {
        return new CallExp(место, e, exps);
    }

    static CallExp создай(Место место, Выражение e)
    {
        return new CallExp(место, e);
    }

    static CallExp создай(Место место, Выражение e, Выражение earg1)
    {
        return new CallExp(место, e, earg1);
    }

    /***********************************************************
    * Creates a new function call Выражение
    * Параметры:
    *       место   = location
    *       fd    = the declaration of the function to call
    *       earg1 = the function argument
    */
    static CallExp создай(Место место, FuncDeclaration fd, Выражение earg1)
    {
        return new CallExp(место, fd, earg1);
    }

    override Выражение syntaxCopy()
    {
        return new CallExp(место, e1.syntaxCopy(), arraySyntaxCopy(arguments));
    }

    override бул isLvalue()
    {
        Тип tb = e1.тип.toBasetype();
        if (tb.ty == Tdelegate || tb.ty == Tpointer)
            tb = tb.nextOf();
        auto tf = tb.isTypeFunction();
        if (tf && tf.isref)
        {
            if (auto dve = e1.isDotVarExp())
                if (dve.var.isCtorDeclaration())
                    return нет;
            return да; // function returns a reference
        }
        return нет;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (isLvalue())
            return this;
        return Выражение.toLvalue(sc, e);
    }

    override Выражение addDtorHook(Scope* sc)
    {
        /* Only need to add dtor hook if it's a тип that needs destruction.
		* Use same logic as VarDeclaration::callScopeDtor()
		*/

        if (auto tf = e1.тип.isTypeFunction())
        {
            if (tf.isref)
                return this;
        }

        Тип tv = тип.baseElemOf();
        if (auto ts = tv.isTypeStruct())
        {
            StructDeclaration sd = ts.sym;
            if (sd.dtor)
            {
                /* Тип needs destruction, so declare a tmp
				* which the back end will recognize and call dtor on
				*/
                auto tmp = copyToTemp(0, "__tmpfordtor", this);
                auto de = new DeclarationExp(место, tmp);
                auto ve = new VarExp(место, tmp);
                Выражение e = new CommaExp(место, de, ve);
                e = e.ВыражениеSemantic(sc);
                return e;
            }
        }
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

FuncDeclaration isFuncAddress(Выражение e, бул* hasOverloads = null)
{
    if (auto ae = e.isAddrExp())
    {
        auto ae1 = ae.e1;
        if (auto ve = ae1.isVarExp())
        {
            if (hasOverloads)
                *hasOverloads = ve.hasOverloads;
            return ve.var.isFuncDeclaration();
        }
        if (auto dve = ae1.isDotVarExp())
        {
            if (hasOverloads)
                *hasOverloads = dve.hasOverloads;
            return dve.var.isFuncDeclaration();
        }
    }
    else
    {
        if (auto soe = e.isSymOffExp())
        {
            if (hasOverloads)
                *hasOverloads = soe.hasOverloads;
            return soe.var.isFuncDeclaration();
        }
        if (auto dge = e.isDelegateExp())
        {
            if (hasOverloads)
                *hasOverloads = dge.hasOverloads;
            return dge.func.isFuncDeclaration();
        }
    }
    return null;
}

/***********************************************************
*/
final class AddrExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.address, __traits(classInstanceSize, AddrExp), e);
    }

    this(ref Место место, Выражение e, Тип t)
    {
        this(место, e);
        тип = t;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class PtrExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.star, __traits(classInstanceSize, PtrExp), e);
        //if (e.тип)
        //  тип = ((TypePointer *)e.тип).следщ;
    }

    this(ref Место место, Выражение e, Тип t)
    {
        super(место, ТОК2.star, __traits(classInstanceSize, PtrExp), e);
        тип = t;
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        if (auto se = e1.isSymOffExp())
        {
            return se.var.checkModify(место, sc, null, флаг);
        }
        else if (auto ae = e1.isAddrExp())
        {
            return ae.e1.checkModifiable(sc, флаг);
        }
        return Modifiable.yes;
    }

    override бул isLvalue()
    {
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        //printf("PtrExp::modifiableLvalue() %s, тип %s\n", вТкст0(), тип.вТкст0());
        return Выражение.modifiableLvalue(sc, e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class NegExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.negate, __traits(classInstanceSize, NegExp), e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class UAddExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.uadd, __traits(classInstanceSize, UAddExp), e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ComExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.tilde, __traits(classInstanceSize, ComExp), e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class NotExp : UnaExp
{
    this(ref Место место, Выражение e)
    {
        super(место, ТОК2.not, __traits(classInstanceSize, NotExp), e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DeleteExp : UnaExp
{
    бул isRAII;        // да if called automatically as a результат of scoped destruction

    this(ref Место место, Выражение e, бул isRAII)
    {
        super(место, ТОК2.delete_, __traits(classInstanceSize, DeleteExp), e);
        this.isRAII = isRAII;
    }

    override Выражение toBoolean(Scope* sc)
    {
        выведиОшибку("`delete` does not give a булean результат");
        return new ErrorExp();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* Possible to cast to one тип while painting to another тип
*/
final class CastExp : UnaExp
{
    Тип to;                    // тип to cast to
    ббайт mod = cast(ббайт)~0;  // MODxxxxx

    this(ref Место место, Выражение e, Тип t)
    {
        super(место, ТОК2.cast_, __traits(classInstanceSize, CastExp), e);
        this.to = t;
    }

    /* For cast(const) and cast(const)
	*/
    this(ref Место место, Выражение e, ббайт mod)
    {
        super(место, ТОК2.cast_, __traits(classInstanceSize, CastExp), e);
        this.mod = mod;
    }

    override Выражение syntaxCopy()
    {
        return to ? new CastExp(место, e1.syntaxCopy(), to.syntaxCopy()) : new CastExp(место, e1.syntaxCopy(), mod);
    }

    override Выражение addDtorHook(Scope* sc)
    {
        if (to.toBasetype().ty == Tvoid)        // look past the cast(проц)
            e1 = e1.addDtorHook(sc);
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class VectorExp : UnaExp
{
    TypeVector to;      // the target vector тип before semantic()
    бцел dim = ~0;      // number of elements in the vector
    OwnedBy ownedByCtfe = OwnedBy.code;

    this(ref Место место, Выражение e, Тип t)
    {
        super(место, ТОК2.vector, __traits(classInstanceSize, VectorExp), e);
        assert(t.ty == Tvector);
        to = cast(TypeVector)t;
    }

    static VectorExp создай(Место место, Выражение e, Тип t)
    {
        return new VectorExp(место, e, t);
    }

    // Same as создай, but doesn't размести memory.
    static проц emplace(UnionExp* pue, Место место, Выражение e, Тип тип)
    {
        emplaceExp!(VectorExp)(pue, место, e, тип);
    }

    override Выражение syntaxCopy()
    {
        return new VectorExp(место, e1.syntaxCopy(), to.syntaxCopy());
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* e1.массив property for vectors.
*
* https://dlang.org/spec/simd.html#properties
*/
final class VectorArrayExp : UnaExp
{
    this(ref Место место, Выражение e1)
    {
        super(место, ТОК2.vectorArray, __traits(classInstanceSize, VectorArrayExp), e1);
    }

    override бул isLvalue()
    {
        return e1.isLvalue();
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        e1 = e1.toLvalue(sc, e);
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* e1 [lwr .. upr]
*
* http://dlang.org/spec/Выражение.html#slice_Выражениеs
*/
final class SliceExp : UnaExp
{
    Выражение upr;             // null if implicit 0
    Выражение lwr;             // null if implicit [length - 1]

    VarDeclaration lengthVar;
    бул upperIsInBounds;       // да if upr <= e1.length
    бул lowerIsLessThanUpper;  // да if lwr <= upr
    бул arrayop;               // an массив operation, rather than a slice

    /************************************************************/
    this(ref Место место, Выражение e1, IntervalExp ie)
    {
        super(место, ТОК2.slice, __traits(classInstanceSize, SliceExp), e1);
        this.upr = ie ? ie.upr : null;
        this.lwr = ie ? ie.lwr : null;
    }

    this(ref Место место, Выражение e1, Выражение lwr, Выражение upr)
    {
        super(место, ТОК2.slice, __traits(classInstanceSize, SliceExp), e1);
        this.upr = upr;
        this.lwr = lwr;
    }

    override Выражение syntaxCopy()
    {
        auto se = new SliceExp(место, e1.syntaxCopy(), lwr ? lwr.syntaxCopy() : null, upr ? upr.syntaxCopy() : null);
        se.lengthVar = this.lengthVar; // bug7871
        return se;
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        //printf("SliceExp::checkModifiable %s\n", вТкст0());
        if (e1.тип.ty == Tsarray || (e1.op == ТОК2.index && e1.тип.ty != Tarray) || e1.op == ТОК2.slice)
        {
            return e1.checkModifiable(sc, флаг);
        }
        return Modifiable.yes;
    }

    override бул isLvalue()
    {
        /* slice Выражение is rvalue in default, but
		* conversion to reference of static массив is only allowed.
		*/
        return (тип && тип.toBasetype().ty == Tsarray);
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        //printf("SliceExp::toLvalue(%s) тип = %s\n", вТкст0(), тип ? тип.вТкст0() : NULL);
        return (тип && тип.toBasetype().ty == Tsarray) ? this : Выражение.toLvalue(sc, e);
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        выведиОшибку("slice Выражение `%s` is not a modifiable lvalue", вТкст0());
        return this;
    }

    override бул isBool(бул результат)
    {
        return e1.isBool(результат);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ArrayLengthExp : UnaExp
{
    this(ref Место место, Выражение e1)
    {
        super(место, ТОК2.arrayLength, __traits(classInstanceSize, ArrayLengthExp), e1);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* e1 [ a0, a1, a2, a3 ,... ]
*
* http://dlang.org/spec/Выражение.html#index_Выражениеs
*/
final class ArrayExp : UnaExp
{
    Выражения* arguments;     // МассивДРК of Выражение's a0..an

    т_мера currentDimension;    // for opDollar
    VarDeclaration lengthVar;

    this(ref Место место, Выражение e1, Выражение index = null)
    {
        super(место, ТОК2.массив, __traits(classInstanceSize, ArrayExp), e1);
        arguments = new Выражения();
        if (index)
            arguments.сунь(index);
    }

    this(ref Место место, Выражение e1, Выражения* args)
    {
        super(место, ТОК2.массив, __traits(classInstanceSize, ArrayExp), e1);
        arguments = args;
    }

    override Выражение syntaxCopy()
    {
        auto ae = new ArrayExp(место, e1.syntaxCopy(), arraySyntaxCopy(arguments));
        ae.lengthVar = this.lengthVar; // bug7871
        return ae;
    }

    override бул isLvalue()
    {
        if (тип && тип.toBasetype().ty == Tvoid)
            return нет;
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        if (тип && тип.toBasetype().ty == Tvoid)
            выведиОшибку("`проц`s have no значение");
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DotExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.dot, __traits(classInstanceSize, DotExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class CommaExp : BinExp
{
    /// This is needed because AssignExp rewrites CommaExp, hence it needs
    /// to trigger the deprecation.
    const бул isGenerated;

    /// Temporary variable to enable / disable deprecation of comma Выражение
    /// depending on the context.
    /// Since most constructor calls are rewritting, the only place where
    /// нет will be passed will be from the parser.
    бул allowCommaExp;


    this(ref Место место, Выражение e1, Выражение e2, бул generated = да)
    {
        super(место, ТОК2.comma, __traits(classInstanceSize, CommaExp), e1, e2);
        allowCommaExp = isGenerated = generated;
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        return e2.checkModifiable(sc, флаг);
    }

    override бул isLvalue()
    {
        return e2.isLvalue();
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        e2 = e2.toLvalue(sc, null);
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        e2 = e2.modifiableLvalue(sc, e);
        return this;
    }

    override бул isBool(бул результат)
    {
        return e2.isBool(результат);
    }

    override Выражение toBoolean(Scope* sc)
    {
        auto ex2 = e2.toBoolean(sc);
        if (ex2.op == ТОК2.error)
            return ex2;
        e2 = ex2;
        тип = e2.тип;
        return this;
    }

    override Выражение addDtorHook(Scope* sc)
    {
        e2 = e2.addDtorHook(sc);
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }

    /**
	* If the argument is a CommaExp, set a флаг to prevent deprecation messages
	*
	* It's impossible to know from CommaExp.semantic if the результат will
	* be используется, hence when there is a результат (тип != проц), a deprecation
	* message is always emitted.
	* However, some construct can produce a результат but won't use it
	* (ExpStatement and for loop increment).  Those should call this function
	* to prevent unwanted deprecations to be emitted.
	*
	* Параметры:
	*   exp = An Выражение that discards its результат.
	*         If the argument is null or not a CommaExp, nothing happens.
	*/
    static проц allow(Выражение exp)
    {
        if (exp)
            if (auto ce = exp.isCommaExp())
                ce.allowCommaExp = да;
    }
}

/***********************************************************
* Mainly just a placeholder
*/
final class IntervalExp : Выражение
{
    Выражение lwr;
    Выражение upr;

    this(ref Место место, Выражение lwr, Выражение upr)
    {
        super(место, ТОК2.interval, __traits(classInstanceSize, IntervalExp));
        this.lwr = lwr;
        this.upr = upr;
    }

    override Выражение syntaxCopy()
    {
        return new IntervalExp(место, lwr.syntaxCopy(), upr.syntaxCopy());
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

final class DelegatePtrExp : UnaExp
{
    this(ref Место место, Выражение e1)
    {
        super(место, ТОК2.delegatePointer, __traits(classInstanceSize, DelegatePtrExp), e1);
    }

    override бул isLvalue()
    {
        return e1.isLvalue();
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        e1 = e1.toLvalue(sc, e);
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        if (sc.func.setUnsafe())
        {
            выведиОшибку("cannot modify delegate pointer in `` code `%s`", вТкст0());
            return new ErrorExp();
        }
        return Выражение.modifiableLvalue(sc, e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DelegateFuncptrExp : UnaExp
{
    this(ref Место место, Выражение e1)
    {
        super(место, ТОК2.delegateFunctionPointer, __traits(classInstanceSize, DelegateFuncptrExp), e1);
    }

    override бул isLvalue()
    {
        return e1.isLvalue();
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        e1 = e1.toLvalue(sc, e);
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        if (sc.func.setUnsafe())
        {
            выведиОшибку("cannot modify delegate function pointer in `` code `%s`", вТкст0());
            return new ErrorExp();
        }
        return Выражение.modifiableLvalue(sc, e);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* e1 [ e2 ]
*/
final class IndexExp : BinExp
{
    VarDeclaration lengthVar;
    бул modifiable = нет;    // assume it is an rvalue
    бул indexIsInBounds;       // да if 0 <= e2 && e2 <= e1.length - 1

    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.index, __traits(classInstanceSize, IndexExp), e1, e2);
        //printf("IndexExp::IndexExp('%s')\n", вТкст0());
    }

    override Выражение syntaxCopy()
    {
        auto ie = new IndexExp(место, e1.syntaxCopy(), e2.syntaxCopy());
        ie.lengthVar = this.lengthVar; // bug7871
        return ie;
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        if (e1.тип.ty == Tsarray ||
            e1.тип.ty == Taarray ||
            (e1.op == ТОК2.index && e1.тип.ty != Tarray) ||
            e1.op == ТОК2.slice)
        {
            return e1.checkModifiable(sc, флаг);
        }
        return Modifiable.yes;
    }

    override бул isLvalue()
    {
        return да;
    }

    override Выражение toLvalue(Scope* sc, Выражение e)
    {
        return this;
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        //printf("IndexExp::modifiableLvalue(%s)\n", вТкст0());
        Выражение ex = markSettingAAElem();
        if (ex.op == ТОК2.error)
            return ex;

        return Выражение.modifiableLvalue(sc, e);
    }

    extern (D) Выражение markSettingAAElem()
    {
        if (e1.тип.toBasetype().ty == Taarray)
        {
            Тип t2b = e2.тип.toBasetype();
            if (t2b.ty == Tarray && t2b.nextOf().isMutable())
            {
                выведиОшибку("associative arrays can only be assigned values with const keys, not `%s`", e2.тип.вТкст0());
                return new ErrorExp();
            }
            modifiable = да;

            if (auto ie = e1.isIndexExp())
            {
                Выражение ex = ie.markSettingAAElem();
                if (ex.op == ТОК2.error)
                    return ex;
                assert(ex == e1);
            }
        }
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* For both i++ and i--
*/
final class PostExp : BinExp
{
    this(ТОК2 op, ref Место место, Выражение e)
    {
        super(место, op, __traits(classInstanceSize, PostExp), e, new IntegerExp(место, 1, Тип.tint32));
        assert(op == ТОК2.minusMinus || op == ТОК2.plusPlus);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* For both ++i and --i
*/
final class PreExp : UnaExp
{
    this(ТОК2 op, ref Место место, Выражение e)
    {
        super(место, op, __traits(classInstanceSize, PreExp), e);
        assert(op == ТОК2.preMinusMinus || op == ТОК2.prePlusPlus);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

enum MemorySet
{
    blockAssign     = 1,    // setting the contents of an массив
    referenceInit   = 2,    // setting the reference of STC.ref_ variable
}

/***********************************************************
*/
class AssignExp : BinExp
{
    цел memset;         // combination of MemorySet flags

    /************************************************************/
    /* op can be ТОК2.assign, ТОК2.construct, or ТОК2.blit */
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.assign, __traits(classInstanceSize, AssignExp), e1, e2);
    }

    this(ref Место место, ТОК2 tok, Выражение e1, Выражение e2)
    {
        super(место, tok, __traits(classInstanceSize, AssignExp), e1, e2);
    }

    override final бул isLvalue()
    {
        // МассивДРК-op 'x[] = y[]' should make an rvalue.
        // Setting массив length 'x.length = v' should make an rvalue.
        if (e1.op == ТОК2.slice || e1.op == ТОК2.arrayLength)
        {
            return нет;
        }
        return да;
    }

    override final Выражение toLvalue(Scope* sc, Выражение ex)
    {
        if (e1.op == ТОК2.slice || e1.op == ТОК2.arrayLength)
        {
            return Выражение.toLvalue(sc, ex);
        }

        /* In front-end уровень, AssignExp should make an lvalue of e1.
		* Taking the address of e1 will be handled in low уровень layer,
		* so this function does nothing.
		*/
        return this;
    }

    override final Выражение toBoolean(Scope* sc)
    {
        // Things like:
        //  if (a = b) ...
        // are usually mistakes.

        выведиОшибку("assignment cannot be используется as a условие, perhaps `==` was meant?");
        return new ErrorExp();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ConstructExp : AssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.construct, e1, e2);
    }

    // Internal use only. If `v` is a reference variable, the assignment
    // will become a reference initialization automatically.
    this(ref Место место, VarDeclaration v, Выражение e2)
    {
        auto ve = new VarExp(место, v);
        assert(v.тип && ve.тип);

        super(место, ТОК2.construct, ve, e2);

        if (v.класс_хранения & (STC.ref_ | STC.out_))
            memset |= MemorySet.referenceInit;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class BlitExp : AssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.blit, e1, e2);
    }

    // Internal use only. If `v` is a reference variable, the assinment
    // will become a reference rebinding automatically.
    this(ref Место место, VarDeclaration v, Выражение e2)
    {
        auto ve = new VarExp(место, v);
        assert(v.тип && ve.тип);

        super(место, ТОК2.blit, ve, e2);

        if (v.класс_хранения & (STC.ref_ | STC.out_))
            memset |= MemorySet.referenceInit;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class AddAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.addAssign, __traits(classInstanceSize, AddAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class MinAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.minAssign, __traits(classInstanceSize, MinAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class MulAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.mulAssign, __traits(classInstanceSize, MulAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class DivAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.divAssign, __traits(classInstanceSize, DivAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ModAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.modAssign, __traits(classInstanceSize, ModAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class AndAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.andAssign, __traits(classInstanceSize, AndAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class OrAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.orAssign, __traits(classInstanceSize, OrAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class XorAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.xorAssign, __traits(classInstanceSize, XorAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class PowAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.powAssign, __traits(classInstanceSize, PowAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ShlAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.leftShiftAssign, __traits(classInstanceSize, ShlAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ShrAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.rightShiftAssign, __traits(classInstanceSize, ShrAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class UshrAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.unsignedRightShiftAssign, __traits(classInstanceSize, UshrAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* The ~= operator. It can have one of the following operators:
*
* ТОК2.concatenateAssign      - appending T[] to T[]
* ТОК2.concatenateElemAssign  - appending T to T[]
* ТОК2.concatenateDcharAssign - appending dchar to T[]
*
* The parser initially sets it to ТОК2.concatenateAssign, and semantic() later decides which
* of the three it will be set to.
*/
class CatAssignExp : BinAssignExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.concatenateAssign, __traits(classInstanceSize, CatAssignExp), e1, e2);
    }

    this(ref Место место, ТОК2 tok, Выражение e1, Выражение e2)
    {
        super(место, tok, __traits(classInstanceSize, CatAssignExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

///
final class CatElemAssignExp : CatAssignExp
{
    this(ref Место место, Тип тип, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.concatenateElemAssign, e1, e2);
        this.тип = тип;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

///
final class CatDcharAssignExp : CatAssignExp
{
    this(ref Место место, Тип тип, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.concatenateDcharAssign, e1, e2);
        this.тип = тип;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#add_Выражениеs
*/
final class AddExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.add, __traits(classInstanceSize, AddExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class MinExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.min, __traits(classInstanceSize, MinExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#cat_Выражениеs
*/
final class CatExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.concatenate, __traits(classInstanceSize, CatExp), e1, e2);
    }

    override Выражение resolveLoc(ref Место место, Scope* sc)
    {
        e1 = e1.resolveLoc(место, sc);
        e2 = e2.resolveLoc(место, sc);
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#mul_Выражениеs
*/
final class MulExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.mul, __traits(classInstanceSize, MulExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#mul_Выражениеs
*/
final class DivExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.div, __traits(classInstanceSize, DivExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#mul_Выражениеs
*/
final class ModExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.mod, __traits(classInstanceSize, ModExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#pow_Выражениеs
*/
final class PowExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.pow, __traits(classInstanceSize, PowExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ShlExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.leftShift, __traits(classInstanceSize, ShlExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ShrExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.rightShift, __traits(classInstanceSize, ShrExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class UshrExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.unsignedRightShift, __traits(classInstanceSize, UshrExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class AndExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.and, __traits(classInstanceSize, AndExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class OrExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.or, __traits(classInstanceSize, OrExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class XorExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.xor, __traits(classInstanceSize, XorExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* http://dlang.org/spec/Выражение.html#andand_Выражениеs
* http://dlang.org/spec/Выражение.html#oror_Выражениеs
*/
final class LogicalExp : BinExp
{
    this(ref Место место, ТОК2 op, Выражение e1, Выражение e2)
    {
        super(место, op, __traits(classInstanceSize, LogicalExp), e1, e2);
        assert(op == ТОК2.andAnd || op == ТОК2.orOr);
    }

    override Выражение toBoolean(Scope* sc)
    {
        auto ex2 = e2.toBoolean(sc);
        if (ex2.op == ТОК2.error)
            return ex2;
        e2 = ex2;
        return this;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* `op` is one of:
*      ТОК2.lessThan, ТОК2.lessOrEqual, ТОК2.greaterThan, ТОК2.greaterOrEqual
*
* http://dlang.org/spec/Выражение.html#relation_Выражениеs
*/
final class CmpExp : BinExp
{
    this(ТОК2 op, ref Место место, Выражение e1, Выражение e2)
    {
        super(место, op, __traits(classInstanceSize, CmpExp), e1, e2);
        assert(op == ТОК2.lessThan || op == ТОК2.lessOrEqual || op == ТОК2.greaterThan || op == ТОК2.greaterOrEqual);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class InExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.in_, __traits(classInstanceSize, InExp), e1, e2);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* This deletes the ключ e1 from the associative массив e2
*/
final class RemoveExp : BinExp
{
    this(ref Место место, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.удали, __traits(classInstanceSize, RemoveExp), e1, e2);
        тип = Тип.tбул;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* `==` and `!=`
*
* ТОК2.equal and ТОК2.notEqual
*
* http://dlang.org/spec/Выражение.html#equality_Выражениеs
*/
final class EqualExp : BinExp
{
    this(ТОК2 op, ref Место место, Выражение e1, Выражение e2)
    {
        super(место, op, __traits(classInstanceSize, EqualExp), e1, e2);
        assert(op == ТОК2.equal || op == ТОК2.notEqual);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* `is` and `!is`
*
* ТОК2.identity and ТОК2.notIdentity
*
*  http://dlang.org/spec/Выражение.html#identity_Выражениеs
*/
final class IdentityExp : BinExp
{
    this(ТОК2 op, ref Место место, Выражение e1, Выражение e2)
    {
        super(место, op, __traits(classInstanceSize, IdentityExp), e1, e2);
        assert(op == ТОК2.identity || op == ТОК2.notIdentity);
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
* `econd ? e1 : e2`
*
* http://dlang.org/spec/Выражение.html#conditional_Выражениеs
*/
final class CondExp : BinExp
{
    Выражение econd;

    this(ref Место место, Выражение econd, Выражение e1, Выражение e2)
    {
        super(место, ТОК2.question, __traits(classInstanceSize, CondExp), e1, e2);
        this.econd = econd;
    }

    override Выражение syntaxCopy()
    {
        return new CondExp(место, econd.syntaxCopy(), e1.syntaxCopy(), e2.syntaxCopy());
    }

    override Modifiable checkModifiable(Scope* sc, цел флаг)
    {
        if (e1.checkModifiable(sc, флаг) != Modifiable.no
            && e2.checkModifiable(sc, флаг) != Modifiable.no)
            return Modifiable.yes;
        return Modifiable.no;
    }

    override бул isLvalue()
    {
        return e1.isLvalue() && e2.isLvalue();
    }

    override Выражение toLvalue(Scope* sc, Выражение ex)
    {
        // convert (econd ? e1 : e2) to *(econd ? &e1 : &e2)
        CondExp e = cast(CondExp)копируй();
        e.e1 = e1.toLvalue(sc, null).addressOf();
        e.e2 = e2.toLvalue(sc, null).addressOf();
        e.тип = тип.pointerTo();
        return new PtrExp(место, e, тип);
    }

    override Выражение modifiableLvalue(Scope* sc, Выражение e)
    {
        //выведиОшибку("conditional Выражение %s is not a modifiable lvalue", вТкст0());
        e1 = e1.modifiableLvalue(sc, e1);
        e2 = e2.modifiableLvalue(sc, e2);
        return toLvalue(sc, this);
    }

    override Выражение toBoolean(Scope* sc)
    {
        auto ex1 = e1.toBoolean(sc);
        auto ex2 = e2.toBoolean(sc);
        if (ex1.op == ТОК2.error)
            return ex1;
        if (ex2.op == ТОК2.error)
            return ex2;
        e1 = ex1;
        e2 = ex2;
        return this;
    }

    проц hookDtors(Scope* sc)
    {
		final class DtorVisitor : StoppableVisitor
        {
            alias  typeof(super).посети посети ;
        public:
            Scope* sc;
            CondExp ce;
            VarDeclaration vcond;
            бул isThen;

            this(Scope* sc, CondExp ce)
            {
                this.sc = sc;
                this.ce = ce;
            }

            override проц посети(Выражение e)
            {
                //printf("(e = %s)\n", e.вТкст0());
            }

            override проц посети(DeclarationExp e)
            {
                auto v = e.declaration.isVarDeclaration();
                if (v && !v.isDataseg())
                {
                    if (v._иниц)
                    {
                        if (auto ei = v._иниц.isExpInitializer())
                            walkPostorder(ei.exp, this);
                    }

                    if (v.edtor)
                        walkPostorder(v.edtor, this);

                    if (v.needsScopeDtor())
                    {
                        if (!vcond)
                        {
                            vcond = copyToTemp(STC.volatile_, "__cond", ce.econd);
                            vcond.dsymbolSemantic(sc);

                            Выражение de = new DeclarationExp(ce.econd.место, vcond);
                            de = de.ВыражениеSemantic(sc);

                            Выражение ve = new VarExp(ce.econd.место, vcond);
                            ce.econd = Выражение.combine(de, ve);
                        }

                        //printf("\t++v = %s, v.edtor = %s\n", v.вТкст0(), v.edtor.вТкст0());
                        Выражение ve = new VarExp(vcond.место, vcond);
                        if (isThen)
                            v.edtor = new LogicalExp(v.edtor.место, ТОК2.andAnd, ve, v.edtor);
                        else
                            v.edtor = new LogicalExp(v.edtor.место, ТОК2.orOr, ve, v.edtor);
                        v.edtor = v.edtor.ВыражениеSemantic(sc);
                        //printf("\t--v = %s, v.edtor = %s\n", v.вТкст0(), v.edtor.вТкст0());
                    }
                }
            }
        }

        scope DtorVisitor v = new DtorVisitor(sc, this);
        //printf("+%s\n", вТкст0());
        v.isThen = да;
        walkPostorder(e1, v);
        v.isThen = нет;
        walkPostorder(e2, v);
        //printf("-%s\n", вТкст0());
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
class DefaultInitExp : Выражение
{
    ТОК2 subop;      // which of the derived classes this is

    this(ref Место место, ТОК2 subop, цел size)
    {
        super(место, ТОК2.default_, size);
        this.subop = subop;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class FileInitExp : DefaultInitExp
{
    this(ref Место место, ТОК2 tok)
    {
        super(место, tok, __traits(classInstanceSize, FileInitExp));
    }

    override Выражение resolveLoc(ref Место место, Scope* sc)
    {
        //printf("FileInitExp::resolve() %s\n", вТкст0());
        ткст0 s;
        if (subop == ТОК2.fileFullPath)
            s = ИмяФайла.toAbsolute(место.isValid() ? место.имяф : sc._module.srcfile.вТкст0());
        else
            s = место.isValid() ? место.имяф : sc._module.идент.вТкст0();

        Выражение e = new StringExp(место, s.вТкстД());
        e = e.ВыражениеSemantic(sc);
        e = e.castTo(sc, тип);
        return e;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class LineInitExp : DefaultInitExp
{
    this(ref Место место)
    {
        super(место, ТОК2.line, __traits(classInstanceSize, LineInitExp));
    }

    override Выражение resolveLoc(ref Место место, Scope* sc)
    {
        Выражение e = new IntegerExp(место, место.номстр, Тип.tint32);
        e = e.castTo(sc, тип);
        return e;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class ModuleInitExp : DefaultInitExp
{
    this(ref Место место)
    {
        super(место, ТОК2.moduleString, __traits(classInstanceSize, ModuleInitExp));
    }

    override Выражение resolveLoc(ref Место место, Scope* sc)
    {
        const auto s = (sc.callsc ? sc.callsc : sc)._module.toPrettyChars().вТкстД();
        Выражение e = new StringExp(место, s);
        e = e.ВыражениеSemantic(sc);
        e = e.castTo(sc, тип);
        return e;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class FuncInitExp : DefaultInitExp
{
    this(ref Место место)
    {
        super(место, ТОК2.functionString, __traits(classInstanceSize, FuncInitExp));
    }

    override Выражение resolveLoc(ref Место место, Scope* sc)
    {
        ткст0 s;
        if (sc.callsc && sc.callsc.func)
            s = sc.callsc.func.ДСимвол.toPrettyChars();
        else if (sc.func)
            s = sc.func.ДСимвол.toPrettyChars();
        else
            s = "";
        Выражение e = new StringExp(место, s.вТкстД());
        e = e.ВыражениеSemantic(sc);
        e.тип = Тип.tstring;
        return e;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/***********************************************************
*/
final class PrettyFuncInitExp : DefaultInitExp
{
    this(ref Место место)
    {
        super(место, ТОК2.prettyFunction, __traits(classInstanceSize, PrettyFuncInitExp));
    }

    override Выражение resolveLoc(ref Место место, Scope* sc)
    {
        FuncDeclaration fd = (sc.callsc && sc.callsc.func)
			? sc.callsc.func
			: sc.func;

        ткст0 s;
        if (fd)
        {
            const funcStr = fd.ДСимвол.toPrettyChars();
            БуфВыв буф;
            functionToBufferWithIdent(fd.тип.isTypeFunction(), &буф, funcStr);
            s = буф.extractChars();
        }
        else
        {
            s = "";
        }

        Выражение e = new StringExp(место, s.вТкстД());
        e = e.ВыражениеSemantic(sc);
        e.тип = Тип.tstring;
        return e;
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}

/**
* Objective-C class reference Выражение.
*
* Used to get the metaclass of an Objective-C class, `NSObject.Class`.
*/
final class ObjcClassReferenceExp : Выражение
{
    ClassDeclaration classDeclaration;

    this(ref Место место, ClassDeclaration classDeclaration)
    {
        super(место, ТОК2.objcClassReference,
			  __traits(classInstanceSize, ObjcClassReferenceExp));
        this.classDeclaration = classDeclaration;
        тип = objc.getRuntimeMetaclass(classDeclaration).getType();
    }

    override проц прими(Визитор2 v)
    {
        v.посети(this);
    }
}
