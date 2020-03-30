/// Author: Aziz Köksal, Vitaly Kulich
/// License: GPL3
/// $(Maturity very high)
module  drc.ast.Visitor;

import drc.ast.Node,
       drc.ast.Declarations,
       drc.ast.Expressions,
       drc.ast.Инструкции,
       drc.ast.Types,
       drc.ast.Parameters;

/// Генерирует методы визита.
///
/// Напр.:
/// ---
/// Декларация посети(ДекларацияКласса){return пусто;};
/// Выражение посети(ВыражениеЗапятая){return пусто;};
/// ---
ткст генерируйМетодыВизита()
{
  ткст текст;
  foreach (имяКласса; г_именаКлассов)
    текст ~= "типВозврата!(\""~имяКласса~"\") посети("~имяКласса~" узел){return узел;}\n";
  return текст;
}
// pragma(сооб, generateAbтктactVisitMethods());

/// Получает соответствующий тип возврата для предложенного класса.
template типВозврата(ткст имяКласса)
{
  static if (is(typeof(mixin(имяКласса)) : Декларация))
    alias Декларация типВозврата;
  else
  static if (is(typeof(mixin(имяКласса)) : Инструкция))
    alias Инструкция типВозврата;
  else
  static if (is(typeof(mixin(имяКласса)) : Выражение))
    alias Выражение типВозврата;
  else
  static if (is(typeof(mixin(имяКласса)) : УзелТипа))
    alias УзелТипа типВозврата;
  else
    alias Узел типВозврата;
}

/// Генерирует функции, выполняющие вторичную отправку.
///
/// Напр.:
/// ---
/// Выражение посетиВыражениеЗапятая(Визитёр визитёр, ВыражениеЗапятая с)
/// { визитёр.посети(с); /* Вторичная отправка. */ }
/// ---
/// Эквивалентом в традиционном духе визитёра был бы:
/// ---
/// class ВыражениеЗапятая : Выражение
/// {
///   проц  прими(Визитёр визитёр)
///   { визитёр.посети(this); }
/// }
/// ---
ткст генерируйФункцииОтправки()
{
  ткст текст;
  foreach (имяКласса; г_именаКлассов)
    текст ~= "типВозврата!(\""~имяКласса~"\") посети"~имяКласса~"(Визитёр визитёр, "~имяКласса~" с)\n"
            "{ return визитёр.посети(с); }\n";
  return текст;
}
// pragma(сооб, генерируйФункцииОтправки());

/++
 Генерирует массив указателей на функцию.

 ---
 [
   cast(ук )&посетиВыражениеЗапятая,
   // и т.д.
 ]
 ---
+/
ткст генерируйВТаблицу()
{
  ткст текст = "[";
  foreach (имяКласса; г_именаКлассов)
    текст ~= "cast(ук) &посети"~имяКласса~",\n";
  return текст[0..$-2]~"]"; // срез away last ",\n"
}
// pragma(сооб, генерируйВТаблицу());

/// Реализует вариацию образца визитёр.
///
/// Наследуется классами, которым нужно обходить синтактическое дерево Ди
/// и выполнять вычисления, трансформации и прочие вещи над ним.
abstract class Визитёр
{
  mixin(генерируйМетодыВизита());

  static
    mixin(генерируйФункцииОтправки());

  //private const _dispatch_vtable = 0;

  // Это необходимо, поскольку компилятор помещает
  // данный массив в сегмент статических данных.
  mixin("private const _dispatch_vtable = " ~ генерируйВТаблицу() ~ ";");

  /// Таблица с указателями на функции второй отправки.
  static const отправь_втаблицу = _dispatch_vtable;
  static assert(отправь_втаблицу.length == г_именаКлассов.length,
                "длина втаблицы не соответствует числу классов");

  /// Ищет функцию второй отправки для n и возвращает её.
  Узел function(Визитёр, Узел) дайФункциюОтправки()(Узел n)
  {
    return cast(Узел function(Визитёр, Узел))отправь_втаблицу[n.вид];
  }

  /// Главная и первая функция отправки.
  Узел отправь(Узел n)
  { // Вторая отправка выполняется в вызванной функции.
    return дайФункциюОтправки(n)(this, n);
  }

final:
  Декларация посети(Декларация n)
  { return посетиД(n); }
  Инструкция посети(Инструкция n)
  { return посетиИ(n); }
  Выражение посети(Выражение n)
  { return посетиВ(n); }
  УзелТипа посети(УзелТипа n)
  { return посетиТ(n); }
  Узел посети(Узел n)
  { return посетиУ(n); }

  Декларация посетиД(Декларация n)
  {
    return cast(Декларация)cast(ук)отправь(n);
  }

  Инструкция посетиИ(Инструкция n)
  {
    return cast(Инструкция)cast(ук)отправь(n);
  }

  Выражение посетиВ(Выражение n)
  {
    return cast(Выражение)cast(ук)отправь(n);
  }

  УзелТипа посетиТ(УзелТипа n)
  {
    return cast(УзелТипа)cast(ук)отправь(n);
  }

  Узел посетиУ(Узел n)
  {
    return отправь(n);
  }
}

//******************************************
import drc.ast.AstCodegen;
import drc.ast.ParsetimeVisitor;
import drc.lexer.Tokens;
import drc.ast.TransitiveVisitor;
import drc.ast.Expression;
import drc.ast.Node;

/**
* Классический класс Визитор2, реализующий методы "посети" для всех узлов АСД,
* присутствующих в компиляторе. Созданные во время разбора методы визита к узлам АСД
* наследуются, но реализуются методы посещения, созданные при семантическом разборе.
*/
class Визитор2 : ВизиторВремениРазбора!(ASTCodegen)
{
    alias ВизиторВремениРазбора!(ASTCodegen).посети посети;
public:
    проц посети(ASTCodegen.ErrorStatement s) { посети(cast(ASTCodegen.Инструкция2)s); }
    проц посети(ASTCodegen.PeelStatement s) { посети(cast(ASTCodegen.Инструкция2)s); }
    проц посети(ASTCodegen.UnrolledLoopStatement s) { посети(cast(ASTCodegen.Инструкция2)s); }
    проц посети(ASTCodegen.SwitchErrorStatement s) { посети(cast(ASTCodegen.Инструкция2)s); }
    проц посети(ASTCodegen.DebugStatement s) { посети(cast(ASTCodegen.Инструкция2)s); }
    проц посети(ASTCodegen.DtorExpStatement s) { посети(cast(ASTCodegen.ExpStatement)s); }
    проц посети(ASTCodegen.ForwardingStatement s) { посети(cast(ASTCodegen.Инструкция2)s); }
    проц посети(ASTCodegen.OverloadSet s) { посети(cast(ASTCodegen.ДСимвол)s); }
    проц посети(ASTCodegen.LabelDsymbol s) { посети(cast(ASTCodegen.ДСимвол)s); }
    проц посети(ASTCodegen.WithScopeSymbol s) { посети(cast(ASTCodegen.ScopeDsymbol)s); }
    проц посети(ASTCodegen.ArrayScopeSymbol s) { посети(cast(ASTCodegen.ScopeDsymbol)s); }
    проц посети(ASTCodegen.OverDeclaration s) { посети(cast(ASTCodegen.Declaration)s); }
    проц посети(ASTCodegen.SymbolDeclaration s) { посети(cast(ASTCodegen.Declaration)s); }
    проц посети(ASTCodegen.ForwardingAttribDeclaration s) { посети(cast(ASTCodegen.AttribDeclaration)s); }
    проц посети(ASTCodegen.ThisDeclaration s) { посети(cast(ASTCodegen.VarDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoDeclaration s) { посети(cast(ASTCodegen.VarDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoStructDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoClassDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoInterfaceDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoPointerDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoArrayDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoStaticArrayDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoAssociativeArrayDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoEnumDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoFunctionDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoDelegateDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoTupleDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoConstDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoInvariantDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoSharedDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoWildDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.TypeInfoVectorDeclaration s) { посети(cast(ASTCodegen.TypeInfoDeclaration)s); }
    проц посети(ASTCodegen.FuncAliasDeclaration s) { посети(cast(ASTCodegen.FuncDeclaration)s); }
    проц посети(ASTCodegen.ErrorInitializer i) { посети(cast(ASTCodegen.Инициализатор)i); }
    проц посети(ASTCodegen.ErrorExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.ComplexExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.StructLiteralExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.ObjcClassReferenceExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.SymOffExp e) { посети(cast(ASTCodegen.SymbolExp)e); }
    проц посети(ASTCodegen.OverExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.HaltExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.DotTemplateExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.DotVarExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.DelegateExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.DotTypeExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.VectorExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.VectorArrayExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.SliceExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.ArrayLengthExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.DelegatePtrExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.DelegateFuncptrExp e) { посети(cast(ASTCodegen.UnaExp)e); }
    проц посети(ASTCodegen.DotExp e) { посети(cast(ASTCodegen.BinExp)e); }
    проц посети(ASTCodegen.IndexExp e) { посети(cast(ASTCodegen.BinExp)e); }
    проц посети(ASTCodegen.ConstructExp e) { посети(cast(ASTCodegen.AssignExp)e); }
    проц посети(ASTCodegen.BlitExp e) { посети(cast(ASTCodegen.AssignExp)e); }
    проц посети(ASTCodegen.RemoveExp e) { посети(cast(ASTCodegen.BinExp)e); }
    проц посети(ASTCodegen.ClassReferenceExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.VoidInitExp e) { посети(cast(ASTCodegen.Выражение)e); }
    проц посети(ASTCodegen.ThrownExceptionExp e) { посети(cast(ASTCodegen.Выражение)e); }
}

/**
* Этот PermissiveVisitor переписывает корневые узлы АСД
* пустыми методами посещения.
*/
class SemanticTimePermissiveVisitor : Визитор2
{
    alias Визитор2.посети посети;

    override проц посети(ASTCodegen.ДСимвол){}
    override проц посети(ASTCodegen.Параметр2){}
    override проц посети(ASTCodegen.Инструкция2){}
    override проц посети(ASTCodegen.Тип){}
    override проц посети(ASTCodegen.Выражение){}
    override проц посети(ASTCodegen.ПараметрШаблона2){}
    override проц посети(ASTCodegen.Condition){}
    override проц посети(ASTCodegen.Инициализатор){}
}

/**
* Этот TransitiveVisitor реализует траверсивную логику АСД для всех узлов АСД.
*/
class SemanticTimeTransitiveVisitor : SemanticTimePermissiveVisitor
{
    alias SemanticTimePermissiveVisitor.посети посети;

    mixin ParseVisitMethods!(ASTCodegen) __methods;
    alias __methods.посети посети;

    override проц посети(ASTCodegen.PeelStatement s)
    {
        if (s.s)
            s.s.прими(this);
    }

    override проц посети(ASTCodegen.UnrolledLoopStatement s)
    {
        foreach(sx; *s.statements)
        {
            if (sx)
                sx.прими(this);
        }
    }

    override проц посети(ASTCodegen.DebugStatement s)
    {
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(ASTCodegen.ForwardingStatement s)
    {
        if (s.инструкция)
            s.инструкция.прими(this);
    }

    override проц посети(ASTCodegen.StructLiteralExp e)
    {
        // CTFE может генерировать структурные литералы, содержащие AddrExp, указывающее на
		// них самих, которые должны избегать бесконечной рекурсии.
        if (!(e.stageflags & stageToCBuffer))
        {
            цел old = e.stageflags;
            e.stageflags |= stageToCBuffer;
            foreach (el; *e.elements)
                if (el)
                    el.прими(this);
            e.stageflags = old;
        }
    }

    override проц посети(ASTCodegen.DotTemplateExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.DotVarExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.DelegateExp e)
    {
        if (!e.func.isNested() || e.func.needThis())
            e.e1.прими(this);
    }

    override проц посети(ASTCodegen.DotTypeExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.VectorExp e)
    {
        visitType(e.to);
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.VectorArrayExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.SliceExp e)
    {
        e.e1.прими(this);
        if (e.upr)
            e.upr.прими(this);
        if (e.lwr)
            e.lwr.прими(this);
    }

    override проц посети(ASTCodegen.ArrayLengthExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.DelegatePtrExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.DelegateFuncptrExp e)
    {
        e.e1.прими(this);
    }

    override проц посети(ASTCodegen.DotExp e)
    {
        e.e1.прими(this);
        e.e2.прими(this);
    }

    override проц посети(ASTCodegen.IndexExp e)
    {
        e.e1.прими(this);
        e.e2.прими(this);
    }

    override проц посети(ASTCodegen.RemoveExp e)
    {
        e.e1.прими(this);
        e.e2.прими(this);
    }
}

class StoppableVisitor : Визитор2
{
    alias Визитор2.посети посети;
public:
    бул stop;

    final this()
    {
    }
}
