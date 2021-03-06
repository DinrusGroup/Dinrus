/// Author: Aziz Köksal, Vitaly Kulich
/// License: GPL3
/// $(Maturity high)
module drc.ast.Инструкции;

public import drc.ast.Инструкция2;
import drc.ast.Node,
       drc.ast.Expression,
       drc.ast.Declaration,
       drc.ast.Type,
       drc.ast.Parameters,
       drc.ast.NodeCopier;
import drc.lexer.IdTable;

class СложнаяИнструкция : Инструкция
{
  this()
  {
    mixin(установить_вид);
  }

  проц  opCatAssign(Инструкция s)
  {
    добавьОтпрыск(s);
  }

  Инструкция[] инстрции()
  {
    return cast(Инструкция[])this.отпрыски;
  }

  проц  инстрции(Инструкция[] инстрции)
  {
    this.отпрыски = инстрции;
  }

  mixin(методКопирования);
}////////////////////////////////
///
class НелегальнаяИнструкция : Инструкция
{
  this()
  {
    mixin(установить_вид);
  }
  mixin(методКопирования);
}////////////////////////////////
///
class ПустаяИнструкция : Инструкция
{
  this()
  {
    mixin(установить_вид);
  }
  mixin(методКопирования);
}//////////////////////
///
class ИнструкцияТелаФункции : Инструкция
{
  Инструкция телоФунк, телоВхо, телоВых;
  Идентификатор* outIdent;
  this()
  {
    mixin(установить_вид);
  }

  проц  завершиКонструкцию()
  {
    добавьОпцОтпрыск(телоФунк);
    добавьОпцОтпрыск(телоВхо);
    добавьОпцОтпрыск(телоВых);
  }

  бул пуст()
  {
    return телоФунк is пусто;
  }

  mixin(методКопирования);
}/////////////////
/// scope
class ИнструкцияМасштаб : Инструкция
{
  Инструкция s;
  this(Инструкция s)
  {
    mixin(установить_вид);
    добавьОтпрыск(s);
    this.s = s;
  }
  mixin(методКопирования);
}///////////////////////////
///
class ИнструкцияСМеткой : Инструкция
{
  Идентификатор* лейбл;
  Инструкция s;
  this(Идентификатор* лейбл, Инструкция s)
  {
    mixin(установить_вид);
    добавьОтпрыск(s);
    this.лейбл = лейбл;
    this.s = s;
  }
  mixin(методКопирования);
}////////////////
///
class ИнструкцияВыражение : Инструкция
{
  Выражение в;
  this(Выражение в)
  {
    mixin(установить_вид);
    добавьОтпрыск(в);
    this.в = в;
  }
  mixin(методКопирования);
}/////////////////
///
class ИнструкцияДекларация : Инструкция
{
  Декларация декл;
  this(Декларация декл)
  {
    mixin(установить_вид);
    добавьОтпрыск(декл);
    this.декл = декл;
  }
  mixin(методКопирования);
}/////////////////////////
/// if
class ИнструкцияЕсли : Инструкция
{
  Инструкция переменная; // ДекларацияАвто или ДекларацияПеременной
  Выражение условие;
  Инструкция телоЕсли;
  Инструкция телоИначе;
  this(Инструкция переменная, Выражение условие, Инструкция телоЕсли, Инструкция телоИначе)
  {
    mixin(установить_вид);
    if (переменная)
      добавьОтпрыск(переменная);
    else
      добавьОтпрыск(условие);
    добавьОтпрыск(телоЕсли);
    добавьОпцОтпрыск(телоИначе);

    this.переменная = переменная;
    this.условие = условие;
    this.телоЕсли = телоЕсли;
    this.телоИначе = телоИначе;
  }
  mixin(методКопирования);
}/////////////////////////////
/// while
class ИнструкцияПока : Инструкция
{
  Выражение условие;
  Инструкция телоПока;
  this(Выражение условие, Инструкция телоПока)
  {
    mixin(установить_вид);
    добавьОтпрыск(условие);
    добавьОтпрыск(телоПока);

    this.условие = условие;
    this.телоПока = телоПока;
  }
  mixin(методКопирования);
}/////////////////////
/// do while
class ИнструкцияДелайПока : Инструкция
{
  Инструкция телоДелай;
  Выражение условие;
  this(Выражение условие, Инструкция телоДелай)
  {
    mixin(установить_вид);
    добавьОтпрыск(телоДелай);
    добавьОтпрыск(условие);

    this.условие = условие;
    this.телоДелай = телоДелай;
  }
  mixin(методКопирования);
}/////////////////////////
/// with
class ИнструкцияПри : Инструкция
{
  Инструкция иниц;
  Выражение условие, инкремент;
  Инструкция телоПри;

  this(Инструкция иниц, Выражение условие, Выражение инкремент, Инструкция телоПри)
  {
    mixin(установить_вид);
    добавьОпцОтпрыск(иниц);
    добавьОпцОтпрыск(условие);
    добавьОпцОтпрыск(инкремент);
    добавьОтпрыск(телоПри);

    this.иниц = иниц;
    this.условие = условие;
    this.инкремент = инкремент;
    this.телоПри = телоПри;
  }
  mixin(методКопирования);
}//////////////////////////
/// foreach
class ИнструкцияСКаждым : Инструкция
{
  ТОК лекс;
  Параметры парамы;
  Выражение агрегат;
  Инструкция телоПри;

  this(ТОК лекс, Параметры парамы, Выражение агрегат, Инструкция телоПри)
  {
    mixin(установить_вид);
    добавьОтпрыски([cast(Узел)парамы, агрегат, телоПри]);

    this.лекс = лекс;
    this.парамы = парамы;
    this.агрегат = агрегат;
    this.телоПри = телоПри;
  }

  /// Возвращает да, если является инструкцией foreach_reverse.
  бул реверсивна()
  {
    return лекс == ТОК.ДляВсех_реверс;
  }

  mixin(методКопирования);
}//////////////////////////////////
///
// version(D2)
// {
class ИнструкцияДиапазонСКаждым : Инструкция
{
  ТОК лекс;
  Параметры парамы;
  Выражение нижний, верхний;
  Инструкция телоПри;

  this(ТОК лекс, Параметры парамы, Выражение нижний, Выражение верхний, Инструкция телоПри)
  {
    mixin(установить_вид);
    добавьОтпрыски([cast(Узел)парамы, нижний, верхний, телоПри]);

    this.лекс = лекс;
    this.парамы = парамы;
    this.нижний = нижний;
    this.верхний = верхний;
    this.телоПри = телоПри;
  }
  mixin(методКопирования);
}////////////////////////////////////
/// switch
class ИнструкцияЩит : Инструкция
{
  Выражение условие;
  Инструкция телоЩит;

  this(Выражение условие, Инструкция телоЩит)
  {
    mixin(установить_вид);
    добавьОтпрыск(условие);
    добавьОтпрыск(телоЩит);

    this.условие = условие;
    this.телоЩит = телоЩит;
  }
  mixin(методКопирования);
}//////////////////////////
/// case
class ИнструкцияРеле : Инструкция
{
  Выражение[] значения;
  Инструкция телоРеле;

  this(Выражение[] значения, Инструкция телоРеле)
  {
    mixin(установить_вид);
    добавьОтпрыски(значения);
    добавьОтпрыск(телоРеле);

    this.значения = значения;
    this.телоРеле = телоРеле;
  }
  mixin(методКопирования);
}/////////////////////////////
/// default
class ИнструкцияДефолт : Инструкция
{
  Инструкция телоДефолта;
  this(Инструкция телоДефолта)
  {
    mixin(установить_вид);
    добавьОтпрыск(телоДефолта);

    this.телоДефолта = телоДефолта;
  }
  mixin(методКопирования);
}/////////////////////////////////
/// continue
class ИнструкцияДалее : Инструкция
{
  Идентификатор* идент;
  this(Идентификатор* идент)
  {
    mixin(установить_вид);
    this.идент = идент;
  }
  mixin(методКопирования);
}//////////////////////////////////
/// break
class ИнструкцияВсё : Инструкция
{
  Идентификатор* идент;
  this(Идентификатор* идент)
  {
    mixin(установить_вид);
    this.идент = идент;
  }
  mixin(методКопирования);
}///////////////////////////
///
class ИнструкцияИтог : Инструкция
{
  Выражение в;
  this(Выражение в)
  {
    mixin(установить_вид);
    добавьОпцОтпрыск(в);
    this.в = в;
  }
  mixin(методКопирования);
}/////////////////////////////////////
/// goto
class ИнструкцияПереход : Инструкция
{
  Идентификатор* идент;
  Выражение вырРеле;
  this(Идентификатор* идент, Выражение вырРеле)
  {
    mixin(установить_вид);
    добавьОпцОтпрыск(вырРеле);
    this.идент = идент;
    this.вырРеле = вырРеле;
  }
  mixin(методКопирования);
}///////////////////////////////
/// for
class ИнструкцияДля : Инструкция
{
  Выражение в;
  Инструкция телоДля;
  this(Выражение в, Инструкция телоДля)
  {
    mixin(установить_вид);
    добавьОтпрыск(в);
    добавьОтпрыск(телоДля);

    this.в = в;
    this.телоДля = телоДля;
  }
  mixin(методКопирования);
}//////////////////////////////
/// synchronized
class ИнструкцияСинхр : Инструкция
{
  Выражение в;
  Инструкция телоСинхр;
  this(Выражение в, Инструкция телоСинхр)
  {
    mixin(установить_вид);
    добавьОпцОтпрыск(в);
    добавьОтпрыск(телоСинхр);

    this.в = в;
    this.телоСинхр = телоСинхр;
  }
  mixin(методКопирования);
}//////////////////////////
/// try
class ИнструкцияПробуй : Инструкция
{
  Инструкция телоПробуй;
  ИнструкцияЛови[] телаЛови;
  ИнструкцияИтожь телоИтожь;
  this(Инструкция телоПробуй, ИнструкцияЛови[] телаЛови, ИнструкцияИтожь телоИтожь)
  {
    mixin(установить_вид);
    добавьОтпрыск(телоПробуй);
    добавьОпцОтпрыски(телаЛови);
    добавьОпцОтпрыск(телоИтожь);

    this.телоПробуй = телоПробуй;
    this.телаЛови = телаЛови;
    this.телоИтожь = телоИтожь;
  }
  mixin(методКопирования);
}///////////////////////////////
/// catch
class ИнструкцияЛови : Инструкция
{
  Параметр парам;
  Инструкция телоЛови;
  this(Параметр парам, Инструкция телоЛови)
  {
    mixin(установить_вид);
    добавьОпцОтпрыск(парам);
    добавьОтпрыск(телоЛови);
    this.парам = парам;
    this.телоЛови = телоЛови;
  }
  mixin(методКопирования);
}///////////////////////
/// finally
class ИнструкцияИтожь : Инструкция
{
  Инструкция телоИтожь;
  this(Инструкция телоИтожь)
  {
    mixin(установить_вид);
    добавьОтпрыск(телоИтожь);
    this.телоИтожь = телоИтожь;
  }
  mixin(методКопирования);
}////////////////////////////
/// scope
class ИнструкцияСтражМасштаба : Инструкция
{
  Идентификатор* условие;
  Инструкция телоМасштаба;
  this(Идентификатор* условие, Инструкция телоМасштаба)
  {
    mixin(установить_вид);
    добавьОтпрыск(телоМасштаба);
    this.условие = условие;
    this.телоМасштаба = телоМасштаба;
  }
  mixin(методКопирования);
}/////////////////////////
/// throw
class ИнструкцияБрось : Инструкция
{
  Выражение в;
  this(Выражение в)
  {
    mixin(установить_вид);
    добавьОтпрыск(в);
    this.в = в;
  }
  mixin(методКопирования);
}////////////////////////////
/// volatile
class ИнструкцияЛетучее : Инструкция
{
  Инструкция телоЛетучего;
  this(Инструкция телоЛетучего)
  {
    mixin(установить_вид);
    добавьОпцОтпрыск(телоЛетучего);
    this.телоЛетучего = телоЛетучего;
  }
  mixin(методКопирования);
}////////////////////////
/// asm{}
class ИнструкцияБлокАсм : Инструкция
{
  СложнаяИнструкция инструкции;
  this(СложнаяИнструкция инструкции)
  {
    mixin(установить_вид);
    добавьОтпрыск(инструкции);
    this.инструкции = инструкции;
  }
  mixin(методКопирования);
}///////////////////
/// asm
class ИнструкцияАсм : Инструкция
{
  Идентификатор* идент;
  Выражение[] операнды;
  this(Идентификатор* идент, Выражение[] операнды)
  {
    mixin(установить_вид);
    добавьОпцОтпрыски(операнды);
    this.идент = идент;
    this.операнды = операнды;
  }
  mixin(методКопирования);
}////////////////////////////
///
class ИнструкцияАсмРасклад : Инструкция
{
  цел число;
  this(цел число)
  {
    mixin(установить_вид);
    this.число = число;
  }
  mixin(методКопирования);
}/////////////////////////
///
class ИнструкцияНелегальныйАсм : НелегальнаяИнструкция
{
  this()
  {
    mixin(установить_вид);
  }
  mixin(методКопирования);
}//////////////////////////
/// pragma
class ИнструкцияПрагма : Инструкция
{
  Идентификатор* идент;
  Выражение[] арги;
  Инструкция телоПрагмы;
  this(Идентификатор* идент, Выражение[] арги, Инструкция телоПрагмы)
  {
    mixin(установить_вид);
    добавьОпцОтпрыски(арги);
    добавьОтпрыск(телоПрагмы);

    this.идент = идент;
    this.арги = арги;
    this.телоПрагмы = телоПрагмы;
  }
  mixin(методКопирования);
}//////////////////////////////
/// mixin
class ИнструкцияСмесь : Инструкция
{
  Выражение выражШаблон;
  Идентификатор* идентСмеси;
  this(Выражение выражШаблон, Идентификатор* идентСмеси)
  {
    mixin(установить_вид);
    добавьОтпрыск(выражШаблон);
    this.выражШаблон = выражШаблон;
    this.идентСмеси = идентСмеси;
  }
  mixin(методКопирования);
}//////////////////////////////
/// static if
class ИнструкцияСтатическоеЕсли : Инструкция
{
  Выражение условие;
  Инструкция телоЕсли, телоИначе;
  this(Выражение условие, Инструкция телоЕсли, Инструкция телоИначе)
  {
    mixin(установить_вид);
    добавьОтпрыск(условие);
    добавьОтпрыск(телоЕсли);
    добавьОпцОтпрыск(телоИначе);
    this.условие = условие;
    this.телоЕсли = телоЕсли;
    this.телоИначе = телоИначе;
  }
  mixin(методКопирования);
}//////////////////////////////////
/// static assert
class ИнструкцияСтатическоеПодтверди : Инструкция
{
  Выражение условие, сообщение;
  this(Выражение условие, Выражение сообщение)
  {
    mixin(установить_вид);
    добавьОтпрыск(условие);
    добавьОпцОтпрыск(сообщение);
    this.условие = условие;
    this.сообщение = сообщение;
  }
  mixin(методКопирования);
}/////////////////////////////
///
abstract class ИнструкцияУсловнойКомпиляции : Инструкция
{
  Сема* услов;
  Инструкция телоГлавного, телоИначе;
  this(Сема* услов, Инструкция телоГлавного, Инструкция телоИначе)
  {
    добавьОтпрыск(телоГлавного);
    добавьОпцОтпрыск(телоИначе);
    this.услов = услов;
    this.телоГлавного = телоГлавного;
    this.телоИначе = телоИначе;
  }
}/////////////////////////////////
/// debug(...)
class ИнструкцияОтладка : ИнструкцияУсловнойКомпиляции
{
  this(Сема* услов, Инструкция телоОтладки, Инструкция телоИначе)
  {
    super(услов, телоОтладки, телоИначе);
    mixin(установить_вид);
  }
  mixin(методКопирования);
}//////////////////////////////
/// version{...}
class ИнструкцияВерсия : ИнструкцияУсловнойКомпиляции
{
  this(Сема* услов, Инструкция телоВерсии, Инструкция телоИначе)
  {
    super(услов, телоВерсии, телоИначе);
    mixin(установить_вид);
  }
  mixin(методКопирования);
}/////////////////////////
