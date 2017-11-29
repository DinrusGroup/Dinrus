/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris, snoyberg

******************************************************************************/

module time.chrono.Hebrew;

private import exception;

private import time.chrono.Calendar;



/**
 * $(ANCHOR _Hebrew)
 * Represents the Hebrew Календарь.
 */
public class Hebrew : Календарь {

  private const бцел[14][7] MonthDays = [
    // месяц                                                    // год тип
    [ 0, 0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0  ], 
    [ 0, 30, 29, 29, 29, 30, 29, 0,  30, 29, 30, 29, 30, 29 ],  // 1
    [ 0, 30, 29, 30, 29, 30, 29, 0,  30, 29, 30, 29, 30, 29 ],  // 2
    [ 0, 30, 30, 30, 29, 30, 29, 0,  30, 29, 30, 29, 30, 29 ],  // 3
    [ 0, 30, 29, 29, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29 ],  // 4
    [ 0, 30, 29, 30, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29 ],  // 5
    [ 0, 30, 30, 30, 29, 30, 30, 29, 30, 29, 30, 29, 30, 29 ]   // 6
  ];

  private const бцел YearOfOneAD = 3760;
  private const бцел DaysToOneAD = cast(цел)(YearOfOneAD * 365.2735);

  private const бцел PartsPerHour = 1080;
  private const бцел PartsPerDay = 24 * PartsPerHour;
  private const бцел DaysPerMonth = 29;
  private const бцел DaysPerMonthFraction = 12 * PartsPerHour + 793;
  private const бцел PartsPerMonth = DaysPerMonth * PartsPerDay + DaysPerMonthFraction;
  private const бцел FirstNewMoon = 11 * PartsPerHour + 204;

  private бцел minYear_ = YearOfOneAD + 1583;
  private бцел maxYear_ = YearOfOneAD + 2240;

  /**
   * Represents the текущ эра.
   */
  public const бцел HEBREW_ERA = 1;

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
    проверьYear(год, эра);
    return getGregorianTime(год, месяц, день, час, минута, секунда, миллисекунда);
  }

  /**
   * Overrопрden. Returns the день of the week in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: A ДеньНедели значение representing the день of the week of время.
   */
  public override ДеньНедели дайДеньНедели(Время время) {
    return cast(ДеньНедели) cast(бцел) ((время.тики / ИнтервалВремени.ТиковВДень + 1) % 7);
  }

  /**
   * Overrопрden. Returns the день of the месяц in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the месяц of время.
   */
  public override бцел дайДеньМесяца(Время время) {
    auto год = дайГод(время);
    auto yearType = getYearType(год);
    auto дни = getStartOfYear(год) - DaysToOneAD;
    auto день = cast(цел)(время.тики / ИнтервалВремени.ТиковВДень) - дни;
    бцел n;
    while (n < 12 && день >= MonthDays[yearType][n + 1]) {
      день -= MonthDays[yearType][n + 1];
      n++;
    }
    return день + 1;
  }

  /**
   * Overrопрden. Returns the день of the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the день of the год of время.
   */
  public override бцел дайДеньГода(Время время) {
    auto год = дайГод(время);
    auto дни = getStartOfYear(год) - DaysToOneAD;
    return (cast(бцел)(время.тики / ИнтервалВремени.ТиковВДень) - дни) + 1;
  }

  /**
   * Overrопрden. Returns the месяц in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the месяц in время.
   */
  public override бцел дайМесяц(Время время) {
    auto год = дайГод(время);
    auto yearType = getYearType(год);
    auto дни = getStartOfYear(год) - DaysToOneAD;
    auto день = cast(цел)(время.тики / ИнтервалВремени.ТиковВДень) - дни;
    бцел n;
    while (n < 12 && день >= MonthDays[yearType][n + 1]) {
      день -= MonthDays[yearType][n + 1];
      n++;
    }
    return n + 1;
  }

  /**
   * Overrопрden. Returns the год in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the год in время.
   */
  public override бцел дайГод(Время время) {
    auto день = cast(бцел)(время.тики / ИнтервалВремени.ТиковВДень) + DaysToOneAD;
    auto low = minYear_, high = maxYear_;
    // Perform a binary ищи.
    while (low <= high) {
      auto mопр = low + (high - low) / 2;
      auto startDay = getStartOfYear(mопр);
      if (день < startDay)
        high = mопр - 1;
      else if (день >= startDay && день < getStartOfYear(mопр + 1))
        return mопр;
      else
        low = mопр + 1;
    }
    return low;
  }

  /**
   * Overrопрden. Returns the эра in the specified Время.
   * Параметры: время = A Время значение.
   * Возвращает: An целое representing the ear in время.
   */
  public override бцел дайЭру(Время время) {
    return HEBREW_ERA;
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
    проверьYear(год, эра);
    return MonthDays[getYearType(год)][месяц];
  }

  /**
   * Overrопрden. Returns the число of дни in the specified _year of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   эра = An целое representing the _era.
   * Возвращает: The число of дни in the specified _year in the specified _era.
   */
  public override бцел дайДниГода(бцел год, бцел эра) {
    return getStartOfYear(год + 1) - getStartOfYear(год);
  }

  /**
   * Overrопрden. Returns the число of месяцы in the specified _year of the specified _era.
   * Параметры:
   *   год = An целое representing the _year.
   *   эра = An целое representing the _era.
   * Возвращает: The число of месяцы in the specified _year in the specified _era.
   */
  public override бцел дайМесяцыГода(бцел год, бцел эра) {
    return високосен_ли(год, эра) ? 13 : 12;
  }

  /**
   * Overrопрden. Indicates whether the specified _year in the specified _era is a leap _year.
   * Параметры: год = An целое representing the _year.
   * Параметры: эра = An целое representing the _era.
   * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
   */
  public override бул високосен_ли(бцел год, бцел эра) {
    проверьYear(год, эра);
    // да if год % 19 == 0, 3, 6, 8, 11, 14, 17
    return ((7 * год + 1) % 19) < 7;
  }

  /**
   * $(I Property.) Overrопрden. Retrieves the список of эры in the текущ Календарь.
   * Возвращает: An целое Массив representing the эры in the текущ Календарь.
   */
  public override бцел[] эры() {
        auto врем = [HEBREW_ERA];
        return врем.dup;
  }

  /**
   * $(I Property.) Overrопрden. Retrieves the определитель associated with the текущ Календарь.
   * Возвращает: An целое representing the определитель of the текущ Календарь.
   */
  public override бцел опр() {
    return ЕВРЕЙСКИЙ;
  }

  private проц проверьYear(бцел год, бцел эра) {
    if ((эра != ТЕКУЩАЯ_ЭРА && эра != HEBREW_ERA) || (год > maxYear_ || год < minYear_))
      throw new ИсклНелегальногоАргумента("Значение was out of range.");
  }

  private бцел getYearType(бцел год) {
    цел yearLength = getStartOfYear(год + 1) - getStartOfYear(год);
    if (yearLength > 380)
      yearLength -= 30;
    switch (yearLength) {
      case 353:
        // "deficient"
        return 1;
      case 383:
        // "deficient" leap
        return 4;
      case 354:
        // "нормаль"
        return 2;
      case 384:
        // "нормаль" leap
        return 5;
      case 355:
        // "complete"
        return 3;
      case 385:
        // "complete" leap
        return 6;
      default:
        break;
    }
    // Satisfies -w
    throw new ИсклНелегальногоАргумента("Значение was not действителен.");
  }

  private бцел getStartOfYear(бцел год) {
    auto месяцы = (235 * год - 234) / 19;
    auto дво = месяцы * DaysPerMonthFraction + FirstNewMoon;
    auto день = месяцы * 29 + (дво / PartsPerDay);
    дво %= PartsPerDay;

    auto ДеньНедели = день % 7;
    if (ДеньНедели == 2 || ДеньНедели == 4 || ДеньНедели == 6) {
      день++;
      ДеньНедели = день % 7;
    }
    if (ДеньНедели == 1 && дво > 15 * PartsPerHour + 204 && !високосен_ли(год, ТЕКУЩАЯ_ЭРА))
      день += 2;
    else if (ДеньНедели == 0 && дво > 21 * PartsPerHour + 589 && високосен_ли(год, ТЕКУЩАЯ_ЭРА))
      день++;
    return день;
  }

  private Время getGregorianTime(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда) {
    auto yearType = getYearType(год);
    auto дни = getStartOfYear(год) - DaysToOneAD + день - 1;
    for (цел i = 1; i <= месяц; i++)
      дни += MonthDays[yearType][i - 1];
    return Время((дни * ИнтервалВремени.ТиковВДень) + дайТикиВремени(час, минута, секунда)) + ИнтервалВремени.изМиллисек(миллисекунда);
  }

}

