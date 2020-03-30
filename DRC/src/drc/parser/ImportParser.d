module drc.parser.ImportParser;

import drc.parser.Parser;
import drc.ast.Node,
       drc.ast.Declarations,
       drc.ast.Инструкции;
import drc.SourceText;
import drc.Enums;
import common;

private alias ТОК T;

/// Облегчённый парсер, который находит лишь инструкции импорта
/// в тексте исходника.
class ПарсерИмпорта : Парсер
{
  this(ИсходныйТекст исхТекст)
  {
    super(исхТекст);
  }

  override СложнаяДекларация старт()
  {
    auto деклы = new СложнаяДекларация;
    super.иниц();
    if (сема.вид == T.Модуль)
      деклы ~= разборДекларацииМодуля();
    while (сема.вид != T.КФ)
      разборДефиницииДекларации(Защита.Нет);
    return деклы;
  }

  проц  разборДефиницииБлокаДеклараций(Защита защ)
  {
    пропусти(T.ЛФСкобка);
    while (сема.вид != T.ПФСкобка && сема.вид != T.КФ)
      разборДефиницииДекларации(защ);
    пропусти(T.ПФСкобка);
  }

  проц  разборБлокаДеклараций(Защита защ)
  {
    switch (сема.вид)
    {
    case T.ЛФСкобка:
      разборДефиницииБлокаДеклараций(защ);
      break;
    case T.Двоеточие:
      далее();
      while (сема.вид != T.ПФСкобка && сема.вид != T.КФ)
        разборДефиницииДекларации(защ);
      break;
    default:
      разборДефиницииДекларации(защ);
    }
  }

  бул пропускДоЗакрывающего(T открывающий, T закрывающий)
  {
    alias сема следщ;
    бцел уровень = 1;
    while (1)
    {
      лексер.возьми(следщ);
      if (следщ.вид == открывающий)
        ++уровень;
      else if (следщ.вид == закрывающий && --уровень == 0)
        return да;
      else if (следщ.вид == T.КФ)
        break;
    }
    return нет;
  }

  проц  пропускДоСемыПослеЗакрКСкобки()
  {
    пропускДоЗакрывающего(T.ЛСкобка, T.ПСкобка);
    далее();
  }

  проц  пропускДоСемыПослеЗакрФСкобки()
  {
    пропускДоЗакрывающего(T.ЛФСкобка, T.ПФСкобка);
    далее();
  }

  проц  пропусти(ТОК2 лекс)
  {
    сема.вид == лекс && далее();
  }

  проц  разборАтрибутаЗащиты()
  {
    Защита защ;
    switch (сема.вид)
    {
    case T.Приватный:
      защ = Защита.Приватный; break;
    case T.Пакет:
      защ = Защита.Пакет; break;
    case T.Защищённый:
      защ = Защита.Защищённый; break;
    case T.Публичный:
      защ = Защита.Публичный; break;
    case T.Экспорт:
      защ = Защита.Экспорт; break;
    default:
      assert(0);
    }
    далее();
    разборБлокаДеклараций(защ);
  }

  проц  разборДефиницииДекларации(Защита защ)
  {
    switch (сема.вид)
    {
    case T.Расклад:
      далее();
      if (сема.вид == T.ЛСкобка)
        далее(), далее(), далее(); // ( Целое )
      разборБлокаДеклараций(защ);
      break;
    case T.Прагма:
      далее();
      пропускДоСемыПослеЗакрКСкобки();
      разборБлокаДеклараций(защ);
      break;
    case T.Экспорт,
         T.Приватный,
         T.Пакет,
         T.Защищённый,
         T.Публичный:
      разборАтрибутаЗащиты();
      break;
    // Классы хранения
    case T.Экстерн:
      далее();
      сема.вид == T.ЛСкобка && пропускДоСемыПослеЗакрКСкобки();
      разборБлокаДеклараций(защ);
      break;
    case T.Конст:
    version(D2)
    {
      if (возьмиСледщ() == T.ЛСкобка)
        goto случай_Декларация;
    }
    case T.Перепись,
         T.Устаревший,
         T.Абстрактный,
         T.Синхронизованный,
         // T.Статический,
         T.Окончательный,
         T.Авто,
         T.Масштаб:
    случай_СтатичАтрибут:
    случай_АтрибутИнвариант:
      далее();
      разборБлокаДеклараций(защ);
      break;
    // Конец классов хранения.
    case T.Алиас, T.Типдеф:
      далее();
      goto случай_Декларация;
    case T.Статический:
      switch (возьмиСледщ())
      {
      case T.Импорт:
        goto случай_Импорт;
      case T.Этот:
        далее(), далее(); // static this
        пропускДоСемыПослеЗакрКСкобки();
        разборТелаФункции();
        break;
      case T.Тильда:
        далее(), далее(), далее(), далее(), далее(); // static ~ this ( )
        разборТелаФункции();
        break;
      case T.Если:
        далее(), далее();
        пропускДоСемыПослеЗакрКСкобки();
        разборБлокаДеклараций(защ);
        if (сема.вид == T.Иначе)
          далее(), разборБлокаДеклараций(защ);
        break;
      case T.Подтвердить:
        далее(), далее(); // static assert
        пропускДоСемыПослеЗакрКСкобки();
        пропусти(T.ТочкаЗапятая);
        break;
      default:
        goto случай_СтатичАтрибут;
      }
      break;
    case T.Импорт:
    случай_Импорт:
      auto декл = разборДекларацииИмпорта();
      декл.установиЗащиту(защ); // Установить атрибут защиты.
      импорты ~= декл.в!(ДекларацияИмпорта);
      break;
    case T.Перечень:
      далее();
      сема.вид == T.Идентификатор && далее();
      if (сема.вид == T.Двоеточие)
      {
        далее();
        while (сема.вид != T.ЛФСкобка && сема.вид != T.КФ)
          далее();
      }
      if (сема.вид == T.ТочкаЗапятая)
        далее();
      else
        пропускДоСемыПослеЗакрФСкобки();
      break;
    case T.Класс:
    case T.Интерфейс:
      далее(), пропусти(T.Идентификатор); // class Идентификатор
      сема.вид == T.ЛСкобка && пропускДоСемыПослеЗакрКСкобки(); // Пропустим template парамы.
      if (сема.вид == T.Двоеточие)
      { // БазовыеКлассы
        далее();
        while (сема.вид != T.ЛФСкобка && сема.вид != T.КФ)
          if (сема.вид == T.ЛСкобка) // Пропустим ( семы... )
            пропускДоСемыПослеЗакрКСкобки();
          else
            далее();
      }
      if (сема.вид == T.ТочкаЗапятая)
        далее();
      else
        разборДефиницииБлокаДеклараций(Защита.Нет);
      break;
    case T.Структура, T.Союз:
      далее(); пропусти(T.Идентификатор);
      сема.вид == T.ЛСкобка && пропускДоСемыПослеЗакрКСкобки();
      if (сема.вид == T.ТочкаЗапятая)
        далее();
      else
        разборДефиницииБлокаДеклараций(Защита.Нет);
      break;
    case T.Тильда:
      далее(); // ~
    case T.Этот:
      далее(); далее(); далее(); // this ( )
      разборТелаФункции();
      break;
    case T.Инвариант:
    version(D2)
    {
      auto следщ = сема;
      if (возьмиПосле(следщ) == T.ЛСкобка)
      {
        if (возьмиПосле(следщ) != T.ПСкобка)
          goto случай_Декларация;
      }
      else
        goto случай_АтрибутИнвариант;
    }
      далее();
      сема.вид == T.ЛСкобка && пропускДоСемыПослеЗакрКСкобки();
      разборТелаФункции();
      break;
    case T.Юниттест:
      далее();
      разборТелаФункции();
      break;
    case T.Отладка:
      далее();
      if (сема.вид == T.Присвоить)
      {
        далее(), далее(), далее(); // = Условие ;
        break;
      }
      if (сема.вид == T.ЛСкобка)
        далее(), далее(), далее(); // ( Условие )
      разборБлокаДеклараций(защ);
      if (сема.вид == T.Иначе)
        далее(), разборБлокаДеклараций(защ);
      break;
    case T.Версия:
      далее();
      if (сема.вид == T.Присвоить)
      {
        далее(), далее(), далее(); // = Условие ;
        break;
      }
      далее(), далее(), далее(); // ( Условие )
      разборБлокаДеклараций(защ);
      if (сема.вид == T.Иначе)
        далее(), разборБлокаДеклараций(защ);
      break;
    case T.Шаблон:
      далее();
      пропусти(T.Идентификатор);
      пропускДоСемыПослеЗакрКСкобки();
      разборДефиницииБлокаДеклараций(Защита.Нет);
      break;
    case T.Нов:
      далее();
      пропускДоСемыПослеЗакрКСкобки();
      разборТелаФункции();
      break;
    case T.Удалить:
      далее();
      пропускДоСемыПослеЗакрКСкобки();
      разборТелаФункции();
      break;
    case T.Смесь:
      while (сема.вид != T.ТочкаЗапятая && сема.вид != T.КФ)
        if (сема.вид == T.ЛСкобка)
          пропускДоСемыПослеЗакрКСкобки();
        else
          далее();
      пропусти(T.ТочкаЗапятая);
      break;
    case T.ТочкаЗапятая:
      далее();
      break;
    // Декларация
    case T.Идентификатор, T.Точка, T.Типа:
    случай_Декларация:
      while (сема.вид != T.ТочкаЗапятая && сема.вид != T.КФ)
        if (сема.вид == T.ЛСкобка)
          пропускДоСемыПослеЗакрКСкобки();
        else if (сема.вид == T.ЛФСкобка)
          пропускДоСемыПослеЗакрФСкобки();
        else
          далее();
      пропусти(T.ТочкаЗапятая);
      break;
    default:
      if (сема.интегральныйТип)
        goto случай_Декларация;
      далее();
    }
  }

  ИнструкцияТелаФункции разборТелаФункции()
  {
    while (1)
    {
      switch (сема.вид)
      {
      case T.ЛФСкобка:
        пропускДоСемыПослеЗакрФСкобки();
        break;
      case T.ТочкаЗапятая:
        далее();
        break;
      case T.Вхо:
        далее();
        пропускДоСемыПослеЗакрФСкобки();
        continue;
      case T.Вых:
        далее();
        if (сема.вид == T.ЛСкобка)
          далее(), далее(), далее(); // ( Идентификатор )
        пропускДоСемыПослеЗакрФСкобки();
        continue;
      case T.Тело:
        далее();
        goto case T.ЛФСкобка;
      default:
      }
      break; // Выйти из цикла.
    }
    return пусто;
  }
}
