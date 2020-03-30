module drc.ast.Parameters;

import drc.ast.Node,
       drc.ast.Type,
       drc.ast.Expression,
       drc.ast.NodeCopier;
import drc.lexer.Identifier;
import drc.Enums;

/// Параметр функции или foreach.
class Параметр : Узел
{
  КлассХранения кхр; /// Класс хранения параметра.
  УзелТипа тип; /// Тип параметра.
  Идентификатор* имя; /// Название параметра.
  Выражение дефЗначение; /// Дефолтное значение инициализации.

  this(КлассХранения кхр, УзелТипа тип, Идентификатор* имя, Выражение дефЗначение)
  {
    super(КатегорияУзла.Иное);
    mixin(установить_вид);
    // тип может быть пусто, если парам находится в иструкции foreach
    добавьОпцОтпрыск(тип);
    добавьОпцОтпрыск(дефЗначение);

    this.кхр = кхр;
    this.тип = тип;
    this.имя = имя;
    this.дефЗначение = дефЗначение;
  }

  /// Возвращает да, если является вариадическим параметром в стиле Ди.
  /// Напр.: функц(цел[] значения ...)
  бул ДиВариадический()
  {
    return вариадический && !СиВариадический;
  }

  /// Возвращает да, если вариадический параметр в стиле Си.
  /// Напр.: функц(...)
  бул СиВариадический()
  {
    return кхр == КлассХранения.Вариадический &&
           тип is пусто && имя is пусто;
  }

  /// Возвращает да, если вариадический параметр в стиле D или к.
  бул вариадический()
  {
    return !!(кхр & КлассХранения.Вариадический);
  }

  /// Возвращает да, если этот параметр lazy.
  бул отложенный()
  {
    return !!(кхр & КлассХранения.Отложенный);
  }

  mixin(методКопирования);
}

/// Массив параметров.
class Параметры : Узел
{
  this()
  {
    super(КатегорияУзла.Иное);
    mixin(установить_вид);
  }

  бул естьВариадические()
  {
    if (отпрыски.length != 0)
      return элементы[$-1].вариадический();
    return нет;
  }

  бул естьЛэйзи()
  {
    foreach(парам; элементы)
      if(парам.отложенный())
        return да;
    return нет;
  }

  проц  opCatAssign(Параметр парам)
  { добавьОтпрыск(парам); }

  Параметр[] элементы()
  { return cast(Параметр[])отпрыски; }

  т_мера length()
  { return отпрыски.length; }

  mixin(методКопирования);
}

/*~~~~~~~~~~~~~~~~~~~~~~
~ Шаблон параметры: ~
~~~~~~~~~~~~~~~~~~~~~~*/

/// Абстрактный класс-основа для всех параметров шаблонов.
abstract class ПараметрШаблона : Узел
{
  Идентификатор* идент;
  this(Идентификатор* идент)
  {
    super(КатегорияУзла.Иное);
    this.идент = идент;
  }
}

/// Напр.: (alias T)
class ПараметрАлиасШаблона : ПараметрШаблона
{
  УзелТипа типСпец, дефТип;
  this(Идентификатор* идент, УзелТипа типСпец, УзелТипа дефТип)
  {
    super(идент);
    mixin(установить_вид);
    добавьОпцОтпрыск(типСпец);
    добавьОпцОтпрыск(дефТип);
    this.идент = идент;
    this.типСпец = типСпец;
    this.дефТип = дефТип;
  }
  mixin(методКопирования);
}

/// Напр.: (T т)
class ПараметрТипаШаблона : ПараметрШаблона
{
  УзелТипа типСпец, дефТип;
  this(Идентификатор* идент, УзелТипа типСпец, УзелТипа дефТип)
  {
    super(идент);
    mixin(установить_вид);
    добавьОпцОтпрыск(типСпец);
    добавьОпцОтпрыск(дефТип);
    this.идент = идент;
    this.типСпец = типСпец;
    this.дефТип = дефТип;
  }
  mixin(методКопирования);
}

// version(D2)
// {
/// Напр.: (this T)
class ПараметрЭтотШаблона : ПараметрШаблона
{
  УзелТипа типСпец, дефТип;
  this(Идентификатор* идент, УзелТипа типСпец, УзелТипа дефТип)
  {
    super(идент);
    mixin(установить_вид);
    добавьОпцОтпрыск(типСпец);
    добавьОпцОтпрыск(дефТип);
    this.идент = идент;
    this.типСпец = типСпец;
    this.дефТип = дефТип;
  }
  mixin(методКопирования);
}
// }

/// Напр.: (T)
class ПараметрШаблонЗначения : ПараметрШаблона
{
  УзелТипа типЗначение;
  Выражение спецЗначение, дефЗначение;
  this(УзелТипа типЗначение, Идентификатор* идент, Выражение спецЗначение, Выражение дефЗначение)
  {
    super(идент);
    mixin(установить_вид);
    добавьОтпрыск(типЗначение);
    добавьОпцОтпрыск(спецЗначение);
    добавьОпцОтпрыск(дефЗначение);
    this.типЗначение = типЗначение;
    this.идент = идент;
    this.спецЗначение = спецЗначение;
    this.дефЗначение = дефЗначение;
  }
  mixin(методКопирования);
}

/// Напр.: (T...)
class ПараметрКортежШаблона : ПараметрШаблона
{
  this(Идентификатор* идент)
  {
    super(идент);
    mixin(установить_вид);
    this.идент = идент;
  }
  mixin(методКопирования);
}

/// МассивДРК параметров шаблона.
class ПараметрыШаблона : Узел
{
  this()
  {
    super(КатегорияУзла.Иное);
    mixin(установить_вид);
  }

  проц  opCatAssign(ПараметрШаблона параметр)
  {
    добавьОтпрыск(параметр);
  }

  ПараметрШаблона[] элементы()
  {
    return cast(ПараметрШаблона[])отпрыски;
  }

  mixin(методКопирования);
}

/// МассивДРК аргументов шаблона.
class АргументыШаблона : Узел
{
  this()
  {
    super(КатегорияУзла.Иное);
    mixin(установить_вид);
  }

  проц  opCatAssign(Узел аргумент)
  {
    добавьОтпрыск(аргумент);
  }

  mixin(методКопирования);
}
