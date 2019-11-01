/// Author: Aziz Köksal, Vitaly Kulich
/// License: GPL3
/// $(Maturity low)
module drc.semantic.Pass1;

import  drc.ast.Visitor,
       drc.ast.Node,
       drc.ast.Declarations,
       drc.ast.Expressions,
       drc.ast.Statements,
       drc.ast.Types,
       drc.ast.Parameters;
import drc.lexer.IdTable;
import drc.semantic.Symbol,
       drc.semantic.Symbols,
       drc.semantic.Types,
       drc.semantic.Scope,
       drc.semantic.Module,
       drc.semantic.Analysis;
import drc.Compilation;
import drc.Diagnostics;
import drc.Messages;
import drc.Enums;
import drc.CompilerInfo;
import common;

import io.model;
alias ФайлКонст.СимПутьРазд папРазд;

/// Первая проходка является декларационной проходкой.
///
/// Основная задача этого класса - обходить дерево разбора,
/// находить любые декларации и добавлять их
/// в таблицу символов соответствующих им масштабов.
class СемантическаяПроходка1 : Визитёр
{
  Масштаб масш; /// Текущий Масштаб.
  Модуль модуль; /// Семантически проверяемый модуль.
  КонтекстКомпиляции контекст; /// Контекст компиляции.
  Модуль delegate(ткст) импортируйМодуль; /// Вызывается при импорте модуля.

  // Атрибуты:
  ТипКомпоновки типКомпоновки; /// Текущий тип компоновки.
  Защита защита; /// Текущий атрибут защиты.
  КлассХранения классХранения; /// Текущие классы хранения.
  бцел размерРаскладки; /// Текуший размер раскладки (align).

  /// Строит объект СемантическаяПроходка1.
  /// Параметры:
  ///   модуль = обрабатываемый модуль.
  ///   контекст = контекст компиляции.
  this(Модуль модуль, КонтекстКомпиляции контекст)
  {
    this.модуль = модуль;
    this.контекст = new КонтекстКомпиляции(контекст);
    this.размерРаскладки = контекст.раскладкаСтруктуры;
  }

  /// Запускает обработку модуля.
  проц  пуск()
  {
    assert(модуль.корень !is пусто);
    // Создаём Масштаб модуля.
    масш = new Масштаб(пусто, модуль);
    модуль.семантическийПроходка = 1;
    посети(модуль.корень);
  }

  /// Вводит в новый Масштаб.
  проц  войдиВМасштаб(СимволМасштаба s)
  {
    масш = масш.войдиВ(s);
  }

  /// Выводит из текущего Масштаба.
  проц  выйдиИзМасштаба()
  {
    масш = масш.выход();
  }

  /// Возвращает да, если является Масштабом модуля.
  бул масштабМодуля()
  {
    return масш.символ.Модуль_ли();
  }

  /// Вставляет символ в текущем Масштабе.
  проц  вставь(Символ символ)
  {
    вставь(символ, символ.имя);
  }

  /// Вставляет символ в текущем Масштабе.
  проц  вставь(Символ символ, Идентификатор* имя)
  {
    auto symX = масш.символ.сыщи(имя);
    if (symX)
      сообщиОКонфликтеСимволов(символ, symX, имя);
    else
      масш.символ.вставь(символ, имя);
    // Установить символ текущего Масштаба как родитель.
    символ.родитель = масш.символ;
  }

  /// Вставляет символ в симМасшт.
  проц  вставь(Символ символ, СимволМасштаба симМасшт)
  {
    auto symX = симМасшт.сыщи(символ.имя);
    if (symX)
      сообщиОКонфликтеСимволов(символ, symX, символ.имя);
    else
      симМасшт.вставь(символ, символ.имя);
    // Установить символ текущего Масштаба как родитель.
    символ.родитель = симМасшт;
  }

  /// Вставляет символ, с перегрузкой имени, в текущий Масштаб.
  проц  вставьПерегрузку(Символ сим)
  {
    auto имя = сим.имя;
    auto сим2 = масш.символ.сыщи(имя);
    if (сим2)
    {
      if (сим2.НаборПерегрузки_ли)
        (cast(НаборПерегрузки)cast(ук)сим2).добавь(сим);
      else
        сообщиОКонфликтеСимволов(сим, сим2, имя);
    }
    else
      // Создать новый набор перегрузки.
      масш.символ.вставь(new НаборПерегрузки(имя, сим.узел), имя);
    // Установить символ текущего Масштаба как родитель.
    сим.родитель = масш.символ;
  }

  /// Отчёт об ошибке: новый символ s1 конфликтует с существующим символом s2.
  проц  сообщиОКонфликтеСимволов(Символ s1, Символ s2, Идентификатор* имя)
  {
    auto место = s2.узел.начало.дайПоложениеОшибки();
    auto локТкст = Формат("{}({},{})", место.путьКФайлу, место.номерСтроки, место.номСтолб);
    ошибка(s1.узел.начало, сооб.ДеклКонфликтуетСДекл, имя.ткт, локТкст);
  }

  /// Создаёт отчёт об ошибке.
  проц  ошибка(Сема* сема, ткст форматирСооб, ...)
  {
    if (!модуль.диаг)
      return;
    auto положение = сема.дайПоложениеОшибки();
    auto сооб = Формат(_arguments, _argptr, форматирСооб);
    модуль.диаг ~= new ОшибкаСемантики(положение, сооб);
  }


  /// Собирает инфу об узлах, которые будут оцениваться позднее.
  static class Иной
  {
    Узел узел;
    СимволМасштаба символ;
    // Сохранённые атрибуты.
    ТипКомпоновки типКомпоновки;
    Защита защита;
    КлассХранения классХранения;
    бцел размерРаскладки;
  }

  /// Список из деклараций mixin, static if, static assert и pragma(сооб,...).
  ///
  /// Их анализ должен отличаться, так как они завершают (entail)
  /// оценку выражения.
  Иной[] deferred;

  /// Добавляет deferred узел в список.
  проц  добавьИной(Узел узел)
  {
    auto d = new Иной;
    d.узел = узел;
    d.символ = масш.символ;
    d.типКомпоновки = типКомпоновки;
    d.защита = защита;
    d.классХранения = классХранения;
    d.размерРаскладки = размерРаскладки;
    deferred ~= d;
  }

  private alias Декларация Д; /// A handy alias. Saves typing.

override
{
  Д посети(СложнаяДекларация d)
  {
    foreach (декл; d.деклы)
      посетиД(декл);
    return d;
  }

  Д посети(НелегальнаяДекларация)
  { assert(0, "семантическая проходка по повреждённому АСД"); return пусто; }

  // Д посети(ПустаяДекларация ed)
  // { return ed; }

  // Д посети(ДекларацияМодуля)
  // { return пусто; }

  Д посети(ДекларацияИмпорта d)
  {
    if (импортируйМодуль is пусто)
      return d;
    foreach (путьПоПКНМодуля; d.дайПКНМодуля(папРазд))
    {
      auto импортированныйМодуль = импортируйМодуль(путьПоПКНМодуля);
      if (импортированныйМодуль is пусто)
        ошибка(d.начало, сооб.МодульНеЗагружен, путьПоПКНМодуля ~ ".d");
      модуль.модули ~= импортированныйМодуль;
    }
    return d;
  }

  Д посети(ДекларацияАлиаса ad)
  {
    return ad;
  }

  Д посети(ДекларацияТипдефа td)
  {
    return td;
  }

  Д посети(ДекларацияПеречня d)
  {
    if (d.символ)
      return d;

    // Создать символ.
    d.символ = new Перечень(d.имя, d);

    бул анонимен = d.символ.анонимен;
    if (анонимен)
      d.символ.имя = ТаблицаИд.генИДАнонПеречня();

    вставь(d.символ);

    auto символРодительскогоМасштаба = масш.символ;
    auto символПеречня = d.символ;
    войдиВМасштаб(d.символ);
    // Объявить члены.
    foreach (член; d.члены)
    {
      посетиД(член);

      if (анонимен) // Также вставим в родительский Масштаб, если перечень анонимен.
        вставь(член.символ, символРодительскогоМасштаба);

      член.символ.тип = символПеречня.тип; // Присвоить ТипПеречень.
    }
    выйдиИзМасштаба();
    return d;
  }

  Д посети(ДекларацияЧленаПеречня d)
  {
    d.символ = new ЧленПеречня(d.имя, защита, классХранения, типКомпоновки, d);
    вставь(d.символ);
    return d;
  }

  Д посети(ДекларацияКласса d)
  {
    if (d.символ)
      return d;
    // Создать символ.
    d.символ = new Класс(d.имя, d);
    // Вставить в текущий Масштаб.
    вставь(d.символ);
    войдиВМасштаб(d.символ);
    // Продолжаем семанализ.
    d.деклы && посетиД(d.деклы);
    выйдиИзМасштаба();
    return d;
  }

  Д посети(ДекларацияИнтерфейса d)
  {
    if (d.символ)
      return d;
    // Создать символ.
    d.символ = new drc.semantic.Symbols.Интерфейс(d.имя, d);
    // Вставить в текущий Масштаб.
    вставь(d.символ);
    войдиВМасштаб(d.символ);
      // Продолжаем семанализ.
      d.деклы && посетиД(d.деклы);
    выйдиИзМасштаба();
    return d;
  }

  Д посети(ДекларацияСтруктуры d)
  {
    if (d.символ)
      return d;
    // Создать символ.
    d.символ = new Структура(d.имя, d);

    if (d.символ.анонимен)
      d.символ.имя = ТаблицаИд.генАнонСтруктИД();
    // Вставить в текущий Масштаб.
    вставь(d.символ);

    войдиВМасштаб(d.символ);
      // Продолжаем семанализ.
      d.деклы && посетиД(d.деклы);
    выйдиИзМасштаба();

    if (d.символ.анонимен)
      // Вставить члены в родительский Масштаб также.
      foreach (член; d.символ.члены)
        вставь(член);
    return d;
  }

  Д посети(ДекларацияСоюза d)
  {
    if (d.символ)
      return d;
    // Создать символ.
    d.символ = new Союз(d.имя, d);

    if (d.символ.анонимен)
      d.символ.имя = ТаблицаИд.генАнонСоюзИД();

    // Вставить в текущий Масштаб.
    вставь(d.символ);

    войдиВМасштаб(d.символ);
      // Продолжаем семанализ.
      d.деклы && посетиД(d.деклы);
    выйдиИзМасштаба();

    if (d.символ.анонимен)
      // Вставить члены в родительский Масштаб также.
      foreach (член; d.символ.члены)
        вставь(член);
    return d;
  }

  Д посети(ДекларацияКонструктора d)
  {
    auto функц = new Функция(Идент.Ктор, d);
    вставьПерегрузку(функц);
    return d;
  }

  Д посети(ДекларацияСтатическогоКонструктора d)
  {
    auto функц = new Функция(Идент.Ктор, d);
    вставьПерегрузку(функц);
    return d;
  }

  Д посети(ДекларацияДеструктора d)
  {
    auto функц = new Функция(Идент.Дтор, d);
    вставьПерегрузку(функц);
    return d;
  }

  Д посети(ДекларацияСтатическогоДеструктора d)
  {
    auto функц = new Функция(Идент.Дтор, d);
    вставьПерегрузку(функц);
    return d;
  }

  Д посети(ДекларацияФункции d)
  {
    auto функц = new Функция(d.имя, d);
    вставьПерегрузку(функц);
    return d;
  }

  Д посети(ДекларацияПеременных vd)
  {
    // Ошибка, если мы в интерфейсе.
    if (масш.символ.Интерфейс_ли && !vd.статический)
      return ошибка(vd.начало, сооб.УИнтерфейсаНеДолжноБытьПеременных), vd;

    // Вставить переменные символы этой декларации в таблицу символов.
    foreach (i, имя; vd.имена)
    {
      auto переменная = new Переменная(имя, защита, классХранения, типКомпоновки, vd);
      переменная.значение = vd.иниты[i];
      vd.переменные ~= переменная;
      вставь(переменная);
    }
    return vd;
  }

  Д посети(ДекларацияИнварианта d)
  {
    auto функц = new Функция(Идент.Инвариант, d);
    вставь(функц);
    return d;
  }

  Д посети(ДекларацияЮниттеста d)
  {
    auto функц = new Функция(Идент.Юниттест, d);
    вставьПерегрузку(функц);
    return d;
  }

  Д посети(ДекларацияОтладки d)
  {
    if (d.определение)
    { // debug = Ид | Цел
      if (!масштабМодуля())
        ошибка(d.начало, сооб.DebugSpecModuleLevel, d.спец.исхТекст);
      else if (d.спец.вид == TOK.Идентификатор)
        контекст.добавьИдОтладки(d.спец.идент.ткт);
      else
        контекст.уровеньОтладки = d.спец.бцел_;
    }
    else
    { // debug ( Условие )
      if (выборОтладВетви(d.услов, контекст))
        d.компилированныеДеклы = d.деклы;
      else
        d.компилированныеДеклы = d.деклыИначе;
      d.компилированныеДеклы && посетиД(d.компилированныеДеклы);
    }
    return d;
  }

  Д посети(ДекларацияВерсии d)
  {
    if (d.определение)
    { // version = Ид | Цел
      if (!масштабМодуля())
        ошибка(d.начало, сооб.УровеньВерсииСпецМодуля, d.спец.исхТекст);
      else if (d.спец.вид == TOK.Идентификатор)
        контекст.добавьИдВерсии(d.спец.идент.ткт);
      else
        контекст.уровеньВерсии = d.спец.бцел_;
    }
    else
    { // version ( Условие )
      if (выборВерсионВетви(d.услов, контекст))
        d.компилированныеДеклы = d.деклы;
      else
        d.компилированныеДеклы = d.деклыИначе;
      d.компилированныеДеклы && посетиД(d.компилированныеДеклы);
    }
    return d;
  }

  Д посети(ДекларацияШаблона d)
  {
    if (d.символ)
      return d;
    // Создать символ.
    d.символ = new Шаблон(d.имя, d);
    // Вставить в текущий Масштаб.
    вставьПерегрузку(d.символ);
    return d;
  }

  Д посети(ДекларацияНов d)
  {
    auto функц = new Функция(Идент.Нов, d);
    вставь(функц);
    return d;
  }

  Д посети(ДекларацияУдали d)
  {
    auto функц = new Функция(Идент.Удалить, d);
    вставь(функц);
    return d;
  }

  // Атрибуты:

  Д посети(ДекларацияЗащиты d)
  {
    auto сохранённое = защита; // Сохранить.
    защита = d.защ; // Установить.
    посетиД(d.деклы);
    защита = сохранённое; // Восстановить.
    return d;
  }

  Д посети(ДекларацияКлассаХранения d)
  {
    auto сохранённое = классХранения; // Сохранить.
    классХранения = d.классХранения; // Установить.
    посетиД(d.деклы);
    классХранения = сохранённое; // Восстановить.
    return d;
  }

  Д посети(ДекларацияКомпоновки d)
  {
    auto сохранённое = типКомпоновки; // Сохранить.
    типКомпоновки = d.типКомпоновки; // Установить.
    посетиД(d.деклы);
    типКомпоновки = сохранённое; // Восстановить.
    return d;
  }

  Д посети(ДекларацияРазложи d)
  {
    auto сохранённое = размерРаскладки; // Сохранить.
    размерРаскладки = d.размер; // Установить.
    посетиД(d.деклы);
    размерРаскладки = сохранённое; // Восстановить.
    return d;
  }

  // Другие декларации:

  Д посети(ДекларацияСтатическогоПодтверди d)
  {
    добавьИной(d);
    return d;
  }

  Д посети(ДекларацияСтатическогоЕсли d)
  {
    добавьИной(d);
    return d;
  }

  Д посети(ДекларацияСмеси d)
  {
    добавьИной(d);
    return d;
  }

  Д посети(ДекларацияПрагмы d)
  {
    if (d.идент is Идент.сооб)
      добавьИной(d);
    else
    {
      семантикаПрагмы(масш, d.начало, d.идент, d.арги);
      посетиД(d.деклы);
    }
    return d;
  }
} // override
}
