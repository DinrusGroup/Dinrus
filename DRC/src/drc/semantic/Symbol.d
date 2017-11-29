/// Author: Aziz Köksal
/// License: GPL3
/// $(Maturity average)
module drc.semantic.Symbol;

import drc.ast.Node;
import drc.lexer.Identifier;
import common;

/// Перечень ИДов символов.
enum СИМ
{
  Модуль,
  Пакет,
  Класс,
  Интерфейс,
  Структура,
  Союз,
  Перечень,
  ЧленПеречня,
  Шаблон,
  Переменная,
  Функция,
  Алиас,
  НаборПерегрузки,
  Масштаб,
//   Тип,
}

/// Символ представляет собой объект с информации о семантике кода.
class Символ
{ /// Перечень состояний символа.
  enum Состояние : бкрат
  {
    Объявлен,   /// Символ был декларирован.
    Обрабатывается, /// Символ обрабатывается.
    Обработан    /// Символ обработан.
  }

  СИМ сид; /// ИД данного символа.
  Состояние состояние; /// Семантическое состояние данного символа.
  Символ родитель; /// Родитель, к которому относится данный символ.
  Идентификатор* имя; /// Название символа.
  /// Узел синтактического дерева, произвёдший данный символ.
  /// Useful for source код положение инфо and retriоцени of doc comments.
  Узел узел;

  /// Строит Символ объект.
  /// Параметры:
  ///   сид = the символ's ID.
  ///   имя = the символ's имя.
  ///   узел = the символ's узел.
  this(СИМ сид, Идентификатор* имя, Узел узел)
  {
    this.сид = сид;
    this.имя = имя;
    this.узел = узел;
  }

  /// Change the состояние в Состояние.Обрабатывается.
  проц  устОбрабатывается()
  { состояние = Состояние.Обрабатывается; }

  /// Change the состояние в Состояние.Обработан.
  проц  устОбработан()
  { состояние = Состояние.Обработан; }

  /// Returns да if the символ is being completed.
  бул обрабатывается_ли()
  { return состояние == Состояние.Обрабатывается; }

  /// Returns да if the символы is complete.
  бул обработан_ли()
  { return состояние == Состояние.Обработан; }

  /// A template macro for building isXYZ() methods.
  private template isX(ткст вид)
  {
    const ткст isX = `бул `~вид~`_ли(){ return сид == СИМ.`~вид~`; }`;
  }
  mixin(isX!("Модуль"));
  mixin(isX!("Пакет"));
  mixin(isX!("Класс"));
  mixin(isX!("Интерфейс"));
  mixin(isX!("Структура"));
  mixin(isX!("Союз"));
  mixin(isX!("Перечень"));
  mixin(isX!("ЧленПеречня"));
  mixin(isX!("Шаблон"));
  mixin(isX!("Переменная"));
  mixin(isX!("Функция"));
  mixin(isX!("Алиас"));
  mixin(isX!("НаборПерегрузки"));
  mixin(isX!("Масштаб"));
//   mixin(isX!("Тип"));

  /// Casts the символ в Класс.
  Класс в(Класс)()
  {
    assert(mixin(`this.сид == mixin("СИМ." ~ Класс.stringof)`));
    return cast(Класс)cast(ук)this;
  }

  /// Возвращает: the fully qualified имя of this символ.
  /// E.g.: drc.semantic.Symbol.Символ.дайПКН
  ткст дайПКН()
  {
    if (!имя)
      return родитель ? родитель.дайПКН() : "";
    if (родитель)
      return родитель.дайПКН() ~ '.' ~ имя.ткт;
    return имя.ткт;
  }
}
