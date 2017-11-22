/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.Hijri;

private import time.chrono.Calendar;


/**
 * $(ANCHOR _Hijri)
 * Represents the Hijri Календарь.
 */
public class Hijri : Календарь {

  private static const бцел[] DAYS_TO_MONTH = [ 0, 30, 59, 89, 118, 148, 177, 207, 236, 266, 295, 325, 355 ];

  /**
   * Represents the текущ эра.
   */
  public const бцел HIJRI_ERA = 1;

  /**
   * Overrопрden. Returns a Время значение установи в_ the specified дата и время in the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   месяц = An целое representing the _month.
   *   день = An целое representing the _day.
   *   час = An целое representing the _hour.
   *   минута = An целое representing the _minute.
   *   секунда = An целое representing the _second.
   *   миллисекунда = An целое representing the _millisecond.
   *   эра = An целое representing the _era.
   * Возвращает: A Время установи в_ the specified дата и время.
   */
  public override Время воВремя(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра) {
    return Время((daysSinceJan1(год, месяц, день) - 1) * ИнтервалВремени.ТиковВДень + дайТикиВремени(час, минута, секунда)) + ИнтервалВремени.изМиллисек(миллисекунда);
  }

  /**
   * Overrопрden. Returns the день of the week in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: A ДеньНедели значение representing the день of the week of время.
   */
  public override ДеньНедели дайДеньНедели(Время время) {
    return cast(ДеньНедели) (cast(бцел) (время.тики / ИнтервалВремени.ТиковВДень + 1) % 7);
  }

  /**
   * Overrопрden. Returns the день of the месяц in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the месяц of время.
   */
  public override бцел дайДеньМесяца(Время время) {
    return откиньЧасть(время.тики, ЧастьДаты.День);
  }

  /**
   * Overrопрden. Returns the день of the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the год of время.
   */
  public override бцел дайДеньГода(Время время) {
    return откиньЧасть(время.тики, ЧастьДаты.ДеньГода);
  }

  /**
   * Overrопрden. Returns the день of the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the год of время.
   */
  public override бцел дайМесяц(Время время) {
    return откиньЧасть(время.тики, ЧастьДаты.Месяц);
  }

  /**
   * Overrопрden. Returns the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the год in время.
   */
  public override бцел дайГод(Время время) {
    return откиньЧасть(время.тики, ЧастьДаты.Год);
  }

  /**
   * Overrопрden. Returns the эра in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the ear in время.
   */
  public override бцел дайЭру(Время время) {
    return HIJRI_ERA;
  }

  /**
   * Overrопрden. Returns the число of дни in the specified _year и _month of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   месяц = An целое representing the _month.
   *   эра = An целое representing the _era.
   * Возвращает: The число of дни in the specified _year и _month of the specified _era.
   */
  public override бцел дайДниМесяца(бцел год, бцел месяц, бцел эра) {
    if (месяц == 12)
      return високосен_ли(год, ТЕКУЩАЯ_ЭРА) ? 30 : 29;
    return (месяц % 2 == 1) ? 30 : 29;
  }

  /**
   * Overrопрden. Returns the число of дни in the specified _year of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   эра = An целое representing the _era.
   * Возвращает: The число of дни in the specified _year in the specified _era.
   */
  public override бцел дайДниГода(бцел год, бцел эра) {
    return високосен_ли(год, эра) ? 355 : 354;
  }

  /**
   * Overrопрden. Returns the число of месяцы in the specified _year of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   эра = An целое representing the _era.
   * Возвращает: The число of месяцы in the specified _year in the specified _era.
   */
  public override бцел дайМесяцыГода(бцел год, бцел эра) {
    return 12;
  }

  /**
   * Overrопрden. Indicates whether the specified _year in the specified _era is a leap _year.
   * Параметры: год = An целое representing the _year.
   * Параметры: эра = An целое representing the _era.
   * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
   */
  public override бул високосен_ли(бцел год, бцел эра) {
    return (14 + 11 * год) % 30 < 11;
  }

  /**
   * $(I Property.) Overrопрden. Retrieves the список of эры in the текущ Календарь.
   * Возвращает: An целое Массив representing the эры in the текущ Календарь.
   */
  public override бцел[] эры() {
    auto врем = [HIJRI_ERA];
    return врем.dup;
  }

  /**
   * $(I Property.) Overrопрden. Retrieves the определитель associated with the текущ Календарь.
   * Возвращает: An целое representing the определитель of the текущ Календарь.
   */
  public override бцел опр() {
    return ХИДЖРИ;
  }

  private дол daysToYear(бцел год) {
    цел cycle = ((год - 1) / 30) * 30;
    цел остаток = год - cycle - 1;
    дол дни = ((cycle * 10631L) / 30L) + 227013L;
    while (остаток > 0) {
      дни += 354 + (високосен_ли(остаток, ТЕКУЩАЯ_ЭРА) ? 1 : 0);
      остаток--;
    }
    return дни;
  }

  private дол daysSinceJan1(бцел год, бцел месяц, бцел день) {
    return cast(дол)(daysToYear(год) + DAYS_TO_MONTH[месяц - 1] + день);
  }

  private цел откиньЧасть(дол тики, ЧастьДаты часть) {
    дол дни = ИнтервалВремени(тики).дни + 1;
    цел год = cast(цел)(((дни - 227013) * 30) / 10631) + 1;
    дол daysUpToYear = daysToYear(год);
    дол daysInYear = дайДниГода(год, ТЕКУЩАЯ_ЭРА);
    if (дни < daysUpToYear) {
      daysUpToYear -= daysInYear;
      год--;
    }
    else if (дни == daysUpToYear) {
      год--;
      daysUpToYear -= дайДниГода(год, ТЕКУЩАЯ_ЭРА);
    }
    else if (дни > daysUpToYear + daysInYear) {
      daysUpToYear += daysInYear;
      год++;
    }

    if (часть == ЧастьДаты.Год)
      return год;

    дни -= daysUpToYear;
    if (часть == ЧастьДаты.ДеньГода)
      return cast(цел)дни;

    цел месяц = 1;
    while (месяц <= 12 && дни > DAYS_TO_MONTH[месяц - 1])
      месяц++;
    месяц--;
    if (часть == ЧастьДаты.Месяц)
      return месяц;

    return cast(цел)(дни - DAYS_TO_MONTH[месяц - 1]);
  }

}

