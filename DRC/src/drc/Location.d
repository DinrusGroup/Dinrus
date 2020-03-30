module drc.Location;

import drc.lexer.Funcs;
import drc.Unicode;

/// Представляет положение в тексте исходника.
final class Положение
{
  сим[] путьКФайлу; /// Путь к файлу.
  т_мера номерСтроки; /// Номер строки.
  ткст0 началоСтроки, в; /// Используется для вычисления столбца.

  static бцел ШИРИНА_ТАБ = 4; /// Дефолтная ширина символа табулятора.

  /// Передает параметры второму конструктору.
  this(сим[] путьКФайлу, т_мера номерСтроки)
  {
    установи(путьКФайлу, номерСтроки);
  }

  /// Конструирует объект Положение.
  this(сим[] путьКФайлу, т_мера номерСтроки, ткст0 началоСтроки, ткст0 в)
  {
    установи(путьКФайлу, номерСтроки, началоСтроки, в);
  }

  проц  установи(сим[] путьКФайлу, т_мера номерСтроки)
  {
    установи(путьКФайлу, номерСтроки, пусто, пусто);
  }

  проц  установи(сим[] путьКФайлу, т_мера номерСтроки, ткст0 началоСтроки, ткст0 в)
  {
    this.путьКФайлу  = путьКФайлу;
    установи(номерСтроки, началоСтроки, в);
  }

  проц  установи(т_мера номерСтроки, ткст0 началоСтроки, ткст0 в)
  {
    assert(началоСтроки <= в);
    this.номерСтроки   = номерСтроки;
    this.началоСтроки = началоСтроки;
    this.в        = в;
  }

  проц  установиПутьКФайлу(сим[] путьКФайлу)
  {
    this.путьКФайлу = путьКФайлу;
  }

  /// Используется простой метод для подсчёта числа символов в тексте.
  ///
 /// Примечание: Составные символы Юникод и прочие особые символы
 /// в расчёт не принимаются.
  /// Параметры:
  ///   ширинаТаб = сирина символа-табулятора.
  бцел вычислиСтолбец(бцел ширинаТаб = Положение.ШИРИНА_ТАБ)
  {
    бцел столб;
    auto у = началоСтроки;
    if (!у)
      return 0;
    for (; у <= в; у++)
    {
      assert(delegate ()
        {
          // Проверить на отсутствие новстр между у и в.
          // Но 'в' может указывать на новстр.
          if (у != в && новСтр(*у))
            return нет;
          if (в-у >= 2 && новСтрЮ(у))
            return нет;
          return да;
        }() == да
      );

      // Пропустить этот байт, если он -  трейл-байт цепочки UTF-8.
      if (ведомыйБайт(*у))
        continue; // *у == 0b10xx_xxxx

      // Only счёт ASCII characters and the first байт of a UTF-8 sequence.
      if (*у == '\t')
        столб += ширинаТаб;
      else
        столб++;
    }
    return столб;
  }
  alias вычислиСтолбец номСтолб;
}
