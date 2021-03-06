/// Author: Aziz Köksal, Vitaly Kulich
/// License: GPL3
/// $(Maturity low)
module drc.semantic.Pass2;

import drc.ast.DefaultVisitor,
       drc.ast.Node,
       drc.ast.Declarations,
       drc.ast.Expressions,
       drc.ast.Инструкции,
       drc.ast.Types,
       drc.ast.Parameters;
import drc.lexer.Identifier;
import drc.semantic.Symbol,
       drc.semantic.Symbols,
       drc.semantic.Types,
       drc.semantic.Scope,
       drc.semantic.Module,
       drc.semantic.Analysis;
import drc.code.Interpreter;
import drc.parser.Parser;
import drc.SourceText;
import drc.Diagnostics;
import drc.Messages;
import drc.Enums;
import drc.CompilerInfo;
import common;

/// Вторая проходка определяет типы символов и типы
/// выражений, и также оценивает их.
class СемантическаяПроходка2 : ДефолтныйВизитёр
{
  Масштаб масш; /// Текущий Масштаб.
  Модуль модуль; /// Модуль, подлежащий семантической проверке.

  /// Строит объект СемантическаяПроходка2.
  /// Параметры:
  ///   модуль = проверяемый модуль.
  this(Модуль модуль)
  {
    this.модуль = модуль;
  }

  /// Начало семантического анализа.
  проц  пуск()
  {
    assert(модуль.корень !is пусто);
    //Создаёт масштаб модуля.
    масш = new Масштаб(пусто, модуль);
    модуль.семантическийПроходка = 2;
    посети(модуль.корень);
  }

  /// Входит в новый Масштаб.
  проц  войдиВМасштаб(СимволМасштаба s)
  {
    масш = масш.войдиВ(s);
  }

  /// Выходит из текущего Масштаба.
  проц  выйдиИзМасштаба()
  {
    масш = масш.выход();
  }

  /// Оценивает и возвращает результат.
  Выражение интерпретируй(Выражение в)
  {
    return Интерпретатор.интерпретируй(в, модуль.диаг);
  }

  /// Создаёт отчёт об ошибке.
  проц  ошибка(Сема* сема, ткст форматирСооб, ...)
  {
    auto положение = сема.дайПоложениеОшибки();
    auto сооб = Формат(_arguments, _argptr, форматирСооб);
    модуль.диаг ~= new ОшибкаСемантики(положение, сооб);
  }

  /// Некоторые удобные псевдонимы.
  private alias Декларация D;
  private alias Выражение E; /// определено
  private alias Инструкция S; /// определено
  private alias УзелТипа T; /// определено

  /// Символ текущего Масштаба, используемый для поиска идентификаторов.
  /// Напр.:
  /// ---
  /// объект.method(); // *) объект, искомый в текущем Масштабе.
  ///                  // *) идМасштаб установлен, если объект есть СимволМасштаба.
  ///                  // *) метод будет искаться в идМасштаб.
  /// drc.ast.Node.Узел узел; // Полностью квалифицированный тип.
  /// ---
  СимволМасштаба идМасштаб;

  /// Ищет символ.
  Символ ищи(Сема* идСем)
  {
    assert(идСем.вид == ТОК2.Идентификатор);
    auto ид = идСем.идент;
    Символ символ;

    if (идМасштаб is пусто)
      символ = масш.ищи(ид);
    else
      символ = идМасштаб.сыщи(ид);

    if (символ is пусто)
      ошибка(идСем, сооб.НеопределенныйИдентификатор, ид.ткт);
    else if (auto масшСимвол = cast(СимволМасштаба)символ)
      идМасштаб = масшСимвол;

    return символ;
  }

override
{
  D посети(СложнаяДекларация d)
  {
    return super.посети(d);
  }

  D посети(ДекларацияПеречня d)
  {
    d.символ.устОбрабатывается();

    Тип тип = Типы.Цел; // Дефолт в цел.
    if (d.типОснова)
      тип = посетиТ(d.типОснова).тип;
    // Установитьбазовый тип перечня.
    d.символ.тип.типОснова = тип;

    // TODO: проверить базовый тип. Должен быть базовым типом или другим перечнем.

    войдиВМасштаб(d.символ);

    foreach (член; d.члены)
    {
      Выражение финальнЗначение;
      член.символ.устОбрабатывается();
      if (член.значение)
      {
        член.значение = посетиВ(член.значение);
        финальнЗначение = интерпретируй(член.значение);
        if (финальнЗначение is Интерпретатор.НЕИ)
          финальнЗначение = new ЦелВыражение(0, d.символ.тип);
      }
      //else
        // TODO: инкрементировать числовую переменную и присвоить ей значение.
      член.символ.значение = финальнЗначение;
      член.символ.устОбработан();
    }

    выйдиИзМасштаба();
    d.символ.устОбработан();
    return d;
  }

  D посети(ДекларацияСмеси md)
  {
    if (md.деклы)
      return md.деклы;
    if (md.выражениеСмеси)
    {
      md.аргумент = посетиВ(md.аргумент);
      auto выр = интерпретируй(md.аргумент);
      if (выр is Интерпретатор.НЕИ)
        return md;
      auto ткстВыр = выр.Является!(ТекстовоеВыражение);
      if (ткстВыр is пусто)
      {
        ошибка(md.начало, сооб.АргументСмесиДБТекстом);
        return md;
      }
      else
      { // Разбор деклараций в ткст.
        auto место = md.начало.дайПоложениеОшибки();
        auto путьКФайлу = место.путьКФайлу;
        auto исходныйТекст = new ИсходныйТекст(путьКФайлу, ткстВыр.дайТекст());
        auto парсер = new Парсер(исходныйТекст, модуль.диаг);
        md.деклы = парсер.старт();
      }
    }
    else
    {
      // TODO: реализовать mixin шаблона.
    }
    return md.деклы;
  }

  // Узлы Типов:

  T посети(ТТип т)
  {
    т.в = посетиВ(т.в);
    т.тип = т.в.тип;
    return т;
  }

  T посети(ТМассив т)
  {
    auto типОснова = посетиТ(т.следщ).тип;
    if (т.ассоциативный)
      т.тип = типОснова.массивИз(посетиТ(т.ассоцТип).тип);
    else if (т.динамический)
      т.тип = типОснова.массивИз();
    else if (т.статический)
    {}
    else
      assert(т.срез);
    return т;
  }

  T посети(ТУказатель т)
  {
    т.тип = посетиТ(т.следщ).тип.укНа();
    return т;
  }

  T посети(КвалифицированныйТип т)
  {
    if (т.лв.Является!(КвалифицированныйТип) is пусто)
      идМасштаб = пусто; // Reset at левый-most тип.
    посетиТ(т.лв);
    посетиТ(т.пв);
    т.тип = т.пв.тип;
    return т;
  }

  T посети(ТИдентификатор т)
  {
    auto идСема = т.начало;
    auto символ = ищи(идСема);
    // TODO: сохранить символ или его тип в т.
    return т;
  }

  T посети(ТЭкземплярШаблона т)
  {
    auto идСема = т.начало;
    auto символ = ищи(идСема);
    // TODO: сохранить символ или его тип в т.
    return т;
  }

  T посети(ТМасштабМодуля т)
  {
    идМасштаб = модуль;
    return т;
  }

  T посети(ИнтегральныйТип т)
  {
    // Маппинг таблицы  видов сем в соответствующий им семантический Тип.
    ТипБаза[ТОК2] семВТип = [
      ТОК2.Сим : Типы.Сим,   ТОК2.Шим : Типы.Шим,   ТОК2.Дим : Типы.Дим, ТОК2.Бул : Типы.Бул,
      ТОК2.Байт : Типы.Байт,   ТОК2.Ббайт : Типы.Ббайт,   ТОК2.Крат : Типы.Крат, ТОК2.Бкрат : Типы.Бкрат,
      ТОК2.Цел : Типы.Цел,    ТОК2.Бцел : Типы.Бцел,    ТОК2.Дол : Типы.Дол,  ТОК2.Бдол : Типы.Бдол,
      ТОК2.Цент : Типы.Цент,   ТОК2.Бцент : Типы.Бцент,
      ТОК2.Плав : Типы.Плав,  ТОК2.Дво : Типы.Дво,  ТОК2.Реал : Типы.Реал,
      ТОК2.Вплав : Типы.Вплав, ТОК2.Вдво : Типы.Вдво, ТОК2.Вреал : Типы.Вреал,
      ТОК2.Кплав : Типы.Кплав, ТОК2.Кдво : Типы.Кдво, ТОК2.Креал : Типы.Креал, ТОК2.Проц : Типы.Проц
    ];
    assert(т.лекс in семВТип);
    т.тип = семВТип[т.лекс];
    return т;
  }

  // Узлы Выражений:

  E посети(ВыражениеРодит в)
  {
    if (!в.тип)
    {
      в.следщ = посетиВ(в.следщ);
      в.тип = в.следщ.тип;
    }
    return в;
  }

  E посети(ВыражениеЗапятая в)
  {
    if (!в.тип)
    {
      в.лв = посетиВ(в.лв);
      в.пв = посетиВ(в.пв);
      в.тип = в.пв.тип;
    }
    return в;
  }

  E посети(ВыражениеИлиИли)
  { return пусто; }

  E посети(ВыражениеИИ)
  { return пусто; }

  E посети(ВыражениеСпецСема в)
  {
    if (в.тип)
      return в.значение;
    switch (в.особаяСема.вид)
    {
    case ТОК2.СТРОКА, ТОК2.ВЕРСИЯ:
      в.значение = new ЦелВыражение(в.особаяСема.бцел_, Типы.Бцел);
      break;
    case ТОК2.ФАЙЛ, ТОК2.ДАТА, ТОК2.ВРЕМЯ, ТОК2.ШТАМПВРЕМЕНИ, ТОК2.ПОСТАВЩИК:
      в.значение = new ТекстовоеВыражение(в.особаяСема.ткт);
      break;
    default:
      assert(0);
    }
    в.тип = в.значение.тип;
    return в.значение;
  }

  E посети(ВыражениеДоллар в)
  {
    if (в.тип)
      return в;
    в.тип = Типы.Т_мера;
    // if (!inArraySubscript)
    //   ошибка("$ can only be in an массив subscript.");
    return в;
  }

  E посети(ВыражениеНуль в)
  {
    if (!в.тип)
      в.тип = Типы.Проц_ук;
    return в;
  }

  E посети(БулевоВыражение в)
  {
    if (в.тип)
      return в;
    в.значение = new ЦелВыражение(в.вБул(), Типы.Бул);
    в.тип = Типы.Бул;
    return в;
  }

  E посети(ЦелВыражение в)
  {
    if (в.тип)
      return в;

    if (в.число & 0x8000_0000_0000_0000)
      в.тип = Типы.Бдол; // 0xFFFF_FFFF_FFFF_FFFF
    else if (в.число & 0xFFFF_FFFF_0000_0000)
      в.тип = Типы.Дол; // 0x7FFF_FFFF_FFFF_FFFF
    else if (в.число & 0x8000_0000)
      в.тип = Типы.Бцел; // 0xFFFF_FFFF
    else
      в.тип = Типы.Цел; // 0x7FFF_FFFF
    return в;
  }

  E посети(ВыражениеРеал в)
  {
    if (!в.тип)
      в.тип = Типы.Дво;
    return в;
  }

  E посети(ВыражениеКомплекс в)
  {
    if (!в.тип)
      в.тип = Типы.Кдво;
    return в;
  }

  E посети(ВыражениеСим в)
  {
    return в;
  }

  E посети(ТекстовоеВыражение в)
  {
    return в;
  }

  E посети(ВыражениеСмесь вс)
  {
    if (вс.тип)
      return вс.выр;
    вс.выр = посетиВ(вс.выр);
    auto выр = интерпретируй(вс.выр);
    if (выр is Интерпретатор.НЕИ)
      return вс;
    auto ткстВыр = выр.Является!(ТекстовоеВыражение);
    if (ткстВыр is пусто)
     ошибка(вс.начало, сооб.АргументСмесиДБТекстом);
    else
    {
      auto место = вс.начало.дайПоложениеОшибки();
      auto путьКФайлу = место.путьКФайлу;
      auto исходныйТекст = new ИсходныйТекст(путьКФайлу, ткстВыр.дайТекст());
      auto парсер = new Парсер(исходныйТекст, модуль.диаг);
      выр = парсер.старт2();
      выр = посетиВ(выр); // Проверка выражения.
    }
    вс.выр = выр;
    вс.тип = выр.тип;
    return вс.выр;
  }

  E посети(ВыражениеИмпорта ви)
  {
    if (ви.тип)
      return ви.выр;
    ви.выр = посетиВ(ви.выр);
    auto выр = интерпретируй(ви.выр);
    if (выр is Интерпретатор.НЕИ)
      return ви;
    auto ткстВыр = выр.Является!(ТекстовоеВыражение);
    //if (ткстВыр is пусто)
    //  ошибка(вс.начало, сооб.ImpилиtArgumentMustBeString);
    // TODO: загрузи файл
    //ви.выр = new ТекстовоеВыражение(loadImpилиtFile(ткстВыр.дайТекст()));
    return ви.выр;
  }
}
}
