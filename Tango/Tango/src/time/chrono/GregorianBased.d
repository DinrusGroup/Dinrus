/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris

******************************************************************************/

module time.chrono.GregorianBased;

private import exception;

private import time.Time;

private import time.chrono.Gregorian;



class ГрегорианВОснове : Грегориан {

  private ДиапазонЭр[] eraRanges_;
  private цел maxYear_, minYear_;
  private цел currentEra_ = -1;

  this() 
  {
    eraRanges_ = ДиапазонЭр.дайДиапазоныЭр(опр);
    maxYear_ = eraRanges_[0].годМаксЭры;
    minYear_ = eraRanges_[0].годМинЭры;
  }

  public override Время воВремя(бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра) {
    год = дайГрегорианскийГод(год, эра);
    return super.воВремя(год, месяц, день, час, минута, секунда, миллисекунда, эра);
  }
  public override бцел дайГод(Время время) {
    auto тики = время.тики;
    auto год = откиньЧасть(время.тики, ЧастьДаты.Год);
    foreach (ДиапазонЭр eraRange; eraRanges_) {
      if (тики >= eraRange.тики)
        return год - eraRange.смещениеГода;
    }
    throw new ИсклНелегальногоАргумента("Значение was out of range.");
  }

  public override бцел дайЭру(Время время) {
    auto тики = время.тики;
    foreach (ДиапазонЭр eraRange; eraRanges_) {
      if (тики >= eraRange.тики)
        return eraRange.эра;
    }
    throw new ИсклНелегальногоАргумента("Значение was out of range.");
  }

  public override бцел[] эры() {
    бцел[] результат;
    foreach (ДиапазонЭр eraRange; eraRanges_)
      результат ~= eraRange.эра;
    return результат;
  }

  private бцел дайГрегорианскийГод(бцел год, бцел эра) {
    if (эра == 0)
      эра = текущаяЭра;
    foreach (ДиапазонЭр eraRange; eraRanges_) {
      if (эра == eraRange.эра) {
        if (год >= eraRange.годМинЭры && год <= eraRange.годМаксЭры)
          return eraRange.смещениеГода + год;
        throw new ИсклНелегальногоАргумента("Значение was out of range.");
      }
    }
    throw new ИсклНелегальногоАргумента("эра значение was not действителен.");
  }

  protected бцел текущаяЭра() {
    if (currentEra_ == -1)
      currentEra_ = ДиапазонЭр.дайТекущуюЭру(опр);
    return currentEra_;
  }
}



package struct ДиапазонЭр {

  private static ДиапазонЭр[][бцел] eraRanges;
  private static бцел[бцел] currentEras;
  private static бул initialized_;

  package бцел эра;
  package дол тики;
  package бцел смещениеГода;
  package бцел годМинЭры;
  package бцел годМаксЭры;

  private static проц инициализуй() {
    if (!initialized_) {
      дол getTicks(бцел год, бцел месяц, бцел день)
      {
        return Грегориан.генерный.дайТикиДаты(год, месяц, день, Грегориан.AD_ERA);
      }
      eraRanges[Грегориан.ЯПОНСКИЙ] ~= ДиапазонЭр(4, getTicks(1989, 1, 8), 1988, 1, Грегориан.MAX_YEAR);
      eraRanges[Грегориан.ЯПОНСКИЙ] ~= ДиапазонЭр(3, getTicks(1926, 12, 25), 1925, 1, 1989);
      eraRanges[Грегориан.ЯПОНСКИЙ] ~= ДиапазонЭр(2, getTicks(1912, 7, 30), 1911, 1, 1926);
      eraRanges[Грегориан.ЯПОНСКИЙ] ~= ДиапазонЭр(1, getTicks(1868, 9, 8), 1867, 1, 1912);
      eraRanges[Грегориан.ТАЙВАНЬСКИЙ] ~= ДиапазонЭр(1, getTicks(1912, 1, 1), 1911, 1, Грегориан.MAX_YEAR);
      eraRanges[Грегориан.КОРЕЙСКИЙ] ~= ДиапазонЭр(1, getTicks(1, 1, 1), -2333, 2334, Грегориан.MAX_YEAR);
      eraRanges[Грегориан.ТАИ] ~= ДиапазонЭр(1, getTicks(1, 1, 1), -543, 544, Грегориан.MAX_YEAR);
      currentEras[Грегориан.ЯПОНСКИЙ] = 4;
      currentEras[Грегориан.ТАЙВАНЬСКИЙ] = 1;
      currentEras[Грегориан.КОРЕЙСКИЙ] = 1;
      currentEras[Грегориан.ТАИ] = 1;
      initialized_ = да;
    }
  }

  package static ДиапазонЭр[] дайДиапазоныЭр(бцел calID) {
    if (!initialized_)
      инициализуй();
    return eraRanges[calID];
  }

  package static бцел дайТекущуюЭру(бцел calID) {
    if (!initialized_)
      инициализуй();
    return currentEras[calID];
  }

  private static ДиапазонЭр opCall(бцел эра, дол тики, бцел смещениеГода, бцел годМинЭры, бцел годПредыдущЭры) {
    ДиапазонЭр eraRange;
    eraRange.эра = эра;
    eraRange.тики = тики;
    eraRange.смещениеГода = смещениеГода;
    eraRange.годМинЭры = годМинЭры;
    eraRange.годМаксЭры = годПредыдущЭры - смещениеГода;
    return eraRange;
  }

}

