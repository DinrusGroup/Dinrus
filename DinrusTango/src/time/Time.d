
module time.Time;
pragma(lib, "dinrus.lib");
import stdrus: фм;

/******************************************************************************

    This struct represents a length of время.  The underlying representation is
    in units of 100ns.  This allows the length of время в_ вринтервал в_ roughly
    +/- 10000 годы.
    
    Notably missing из_ this is a representation of weeks, месяцы и годы.
    This is because weeks, месяцы, и годы vary according в_ local Календарьs.
    Use time.chrono.* в_ deal with these concepts.

    Note: nobody should change this struct without really good резон as it is
    требуется в_ be a часть of some interfaces.  It should be treated as a
    builtin тип. Also note that there is deliberately no opCall constructor
    here, since it tends в_ произведи too much overhead.   If you wish в_ build
    a ИнтервалВремени struct из_ a тики значение, use D's builtin ability в_ создай a
    struct with given member значения (See the descrИПtion of тики() for an
    example of как в_ do this).

    Example:
    -------------------
    Время старт = Часы.сейчас;
    Нить.сон(0.150);
    Стдвыв.форматнс("slept for {} ms", (Часы.сейчас-старт).миллисек);
    -------------------

    See_Also: thread, time.Clock

******************************************************************************/

struct ИнтервалВремени
{
        // this is the only member of the struct.
         дол тики_;

        // useful constants.  Shouldn't be использован in нормаль код, use the
        // static ИнтервалВремени члены below instead.  i.e. instead of
        // ИнтервалВремени.ТиковВСек, use ИнтервалВремени.секунда.тики
        //
        enum : дол 
        {
                /// basic tick значения
                НаносекВТике  = 100,
                ТиковВМикросек = 1000 / НаносекВТике,
                ТиковВМиллисек = 1000 * ТиковВМикросек,
                ТиковВСек      = 1000 * ТиковВМиллисек,
                ТиковВМин      = 60 * ТиковВСек,
                ТиковВЧас        = 60 * ТиковВМин,
                ТиковВДень         = 24 * ТиковВЧас,

                // миллисекунда counts
                МиллисекВСек     = 1000,
                МиллисекВМин     = МиллисекВСек * 60,
                МиллисекВЧас       = МиллисекВМин * 60,
                МиллисекВДень        = МиллисекВЧас * 24,

                /// день counts
                ДнейВГоду         = 365,
                ДнейНа4Года       = ДнейВГоду * 4 + 1,
                ДнейНа100Лет     = ДнейНа4Года * 25 - 1,
                ДнейНа400Лет     = ДнейНа100Лет * 4 + 1,

                // эпоха counts
                Эпоха1601           = ДнейНа400Лет * 4 * ТиковВДень,
                Эпоха1970           = Эпоха1601 + ТиковВСек * 11644473600L,
		}
		
	const дво	МиллисекНаТик = 1.0 / ТиковВМиллисек;
	const дво    СекНаТик = 1.0 / ТиковВСек;
	const дво   МинутНаТик = 1.0 / ТиковВМин;		
		

        /**
         * Minimum ИнтервалВремени
         */
		 
        /**
         * Minimum ИнтервалВремени
         */
        static ИнтервалВремени мин = {дол.min};

        /**
         * Maximum ИнтервалВремени
         */
        static ИнтервалВремени макс = {дол.max};

        /**
         * Zero ИнтервалВремени.  Useful for comparisons.
         */
        static ИнтервалВремени нуль = {0};
		
		 
/+		  /**
   * Initializes a new instance.
   * Параметры: ticks = A time period expressed in 100-nanosecond units.
   */
    ИнтервалВремени opCall(дол тики) {
    this.тики_ = тики;
    return *cast(ИнтервалВремени*) this;
	}
	
	  /**
   * Initializes a new instance.
   * Параметры:
   *  hours = Number of _hours.
   *  minutes = Number of _minutes.
   *  seconds = Number of _seconds.
   */
    ИнтервалВремени opCall(цел часы, цел минуты, цел секунды) {
    this.тики_ = (часы * 3600 + минуты * 60 + секунды) * ТиковВСек;
    return *cast(ИнтервалВремени*) this;
  }

  /**
   * Initializes a new instance.
   * Параметры:
   *  days = Number of _days.
   *  hours = Number of _hours.
   *  minutes = Number of _minutes.
   *  seconds = Number of _seconds.
   *  milliseconds = Number of _milliseconds.
   */
    ИнтервалВремени opCall(цел дни, цел часы, цел минуты, цел секунды, цел миллисекунды = 0) {
    this.тики_ = ((дни * 3600 * 24 + часы * 3600 + минуты * 60 + секунды) * 1000 + миллисекунды) * ТиковВМиллисек;
    return *cast(ИнтервалВремени*) this;
  }
    
+/
        /**
         * Get the число of тики that this timespan represents.  This can be
         * использован в_ construct другой ИнтервалВремени:
         *
         * --------
         * дол тики = myTimeSpan.тики;
         * ИнтервалВремени copyOfMyTimeSpan = ИнтервалВремени(тики);
         * --------
         */
        дол тики()
        {
                return тики_;
        }

        /**
         * Determines whether two ИнтервалВремени значения are equal
         */
        бул opEquals(ИнтервалВремени t)
        {
                return тики_ is t.тики_;
        }

        /**
         * Compares this объект against другой ИнтервалВремени значение.
         */
        цел opCmp(ИнтервалВремени t)
        {
                if (тики_ < t.тики_)
                    return -1;

                if (тики_ > t.тики_)
                    return 1;

                return 0;
        }

        /**
         * Добавь the ИнтервалВремени given в_ this ИнтервалВремени returning a new ИнтервалВремени.
         *
         * Параметры: t = A ИнтервалВремени значение в_ добавь
         * Возвращает: A ИнтервалВремени значение that is the sum of this экземпляр и t.
         */
        ИнтервалВремени opAdd(ИнтервалВремени t)
        {
                return ИнтервалВремени(тики_ + t.тики_);
        }

        /**
         * Добавь the specified ИнтервалВремени в_ this ИнтервалВремени, assigning the результат
         * в_ this экземпляр.
         *
         * Параметры: t = A ИнтервалВремени значение в_ добавь
         * Возвращает: a копируй of this экземпляр after добавим t.
         */
        ИнтервалВремени opAddAssign(ИнтервалВремени t)
        {
                тики_ += t.тики_;
                return *this;
        }

        /**
         * Subtract the specified ИнтервалВремени из_ this ИнтервалВремени.
         *
         * Параметры: t = A ИнтервалВремени в_ вычти
         * Возвращает: A new timespan which is the difference between this
         * экземпляр и t
         */
        ИнтервалВремени opSub(ИнтервалВремени t)
        {
                return ИнтервалВремени(тики_ - t.тики_);
        }

        /**
         *
         * Subtract the specified ИнтервалВремени из_ this ИнтервалВремени и присвой the
         *
         * Параметры: t = A ИнтервалВремени в_ вычти
         * Возвращает: A копируй of this экземпляр after subtracting t.
         */
        ИнтервалВремени opSubAssign(ИнтервалВремени t)
        {
                тики_ -= t.тики_;
                return *this;
        }

        /**
         * Scale the ИнтервалВремени by the specified amount.  This should not be
         * использован в_ преобразуй в_ a different unit.  Use the unit accessors
         * instead.  This should only be использован as a scaling mechanism.  For
         * example, if you have a таймаут и you want в_ сон for twice the
         * таймаут, you would use таймаут * 2.
         *
         * Параметры: v = A множитель в_ use for scaling this время вринтервал.
         * Возвращает: A new ИнтервалВремени that is scaled by v
         */
        ИнтервалВремени opMul(дол v)
        {
                return ИнтервалВремени(тики_ * v);
        }

        /**
         * Scales this ИнтервалВремени и assigns the результат в_ this экземпляр.
         *
         * Параметры: v = A multИПler в_ use for scaling
         * Возвращает: A копируй of this экземпляр after scaling
         */
        ИнтервалВремени opMulAssign(дол v)
        {
                тики_ *= v;
                return *this;
        }

        /**
         * Divопрe the ИнтервалВремени by the specified amount.  This should not be
         * использован в_ преобразуй в_ a different unit.  Use the unit accessors
         * instead.  This should only be использован as a scaling mechanism.  For
         * example, if you have a таймаут и you want в_ сон for half the
         * таймаут, you would use таймаут / 2.
         *
         *
         * Параметры: v = A divisor в_ use for scaling this время вринтервал.
         * Возвращает: A new ИнтервалВремени that is divопрed by v
         */
        ИнтервалВремени opDiv(дол v)
        {
                return ИнтервалВремени(тики_ / v);
        }

        /**
         * Divопрes this ИнтервалВремени и assigns the результат в_ this экземпляр.
         *
         * Параметры: v = A multИПler в_ use for divопрing
         * Возвращает: A копируй of this экземпляр after divопрing
         */
        ИнтервалВремени opDivAssign(дол v)
        {
                тики_ /= v;
                return *this;
        }

        /**
         * Perform целое division with the given время вринтервал.
         *
         * Параметры: t = A divisor использован for divопрing
         * Возвращает: The результат of целое division between this экземпляр и
         * t.
         */
        дол opDiv(ИнтервалВремени t)
        {
                return тики_ / t.тики;
        }

        /**
         * Negate a время вринтервал
         *
         * Возвращает: The негатив equivalent в_ this время вринтервал
         */
        ИнтервалВремени opNeg()
        {
                return ИнтервалВремени(-тики_);
        }

        /**
         * Convert в_ nanoseconds
         *
         * Note: this may incur loss of данные because nanoseconds cannot
         * represent the range of данные a ИнтервалВремени can represent.
         *
         * Возвращает: The число of nanoseconds that this ИнтервалВремени represents.
         */
        дол наносек()
        {
                return тики_ * НаносекВТике;
        }

        /**
         * Convert в_ микросекунды
         *
         * Возвращает: The число of микросекунды that this ИнтервалВремени represents.
         */
        дол микросек()
        {
                return тики_ / ТиковВМикросек;
        }

        /**
         * Convert в_ milliseconds
         *
         * Возвращает: The число of milliseconds that this ИнтервалВремени represents.
         */
        дол миллисек()
        {
                return тики_ / ТиковВМиллисек;
        }

        /**
         * Convert в_ сек
         *
         * Возвращает: The число of сек that this ИнтервалВремени represents.
         */
        дол сек()
        {
                return тики_ / ТиковВСек;
        }

        /**
         * Convert в_ минуты
         *
         * Возвращает: The число of минуты that this ИнтервалВремени represents.
         */
        дол минуты()
        {
                return тики_ / ТиковВМин;
        }

        /**
         * Convert в_ часы
         *
         * Возвращает: The число of часы that this ИнтервалВремени represents.
         */
        дол часы()
        {
                return тики_ / ТиковВЧас;
        }

        /**
         * Convert в_ дни
         *
         * Возвращает: The число of дни that this ИнтервалВремени represents.
         */
        дол дни()
        {
                return тики_ / ТиковВДень;
        }

        /**
         * Convert в_ a floating точка интервал representing сек.
         *
         * Note: This may cause a loss of точность as a дво cannot exactly
         * represent some fractional значения.
         *
         * Возвращает: An интервал representing the сек и fractional
         * сек that this ИнтервалВремени represents.
         */
        дво интервал()
        {
                return (cast(дво) тики_) / ТиковВСек;
        }

        /**
         * Convert в_ ВремяДня
         *
         * Возвращает: the ВремяДня this ИнтервалВремени represents.
         */
        ВремяДня время()
        {
                return ВремяДня(тики_);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of nanoseconds
         *
         * Note: This may cause a loss of данные since a ИнтервалВремени's resolution
         * is in 100ns increments.
         *
         * Параметры: значение = The число of nanoseconds.
         * Возвращает: A ИнтервалВремени representing the given число of nanoseconds.
         */
        static ИнтервалВремени изНаносек(дол значение)
        {
                return ИнтервалВремени(значение / НаносекВТике);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of микросекунды
         *
         * Параметры: значение = The число of микросекунды.
         * Возвращает: A ИнтервалВремени representing the given число of микросекунды.
         */
        static ИнтервалВремени изМикросек(дол значение)
        {
                return ИнтервалВремени(ТиковВМикросек * значение);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of milliseconds
         *
         * Параметры: значение = The число of milliseconds.
         * Возвращает: A ИнтервалВремени representing the given число of milliseconds.
         */
        static ИнтервалВремени изМиллисек(дол значение)
        {
                return ИнтервалВремени(ТиковВМиллисек * значение);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of сек
         *
         * Параметры: значение = The число of сек.
         * Возвращает: A ИнтервалВремени representing the given число of сек.
         */
        static ИнтервалВремени изСек(дол значение)
        {
                return ИнтервалВремени(ТиковВСек * значение);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of минуты
         *
         * Параметры: значение = The число of минуты.
         * Возвращает: A ИнтервалВремени representing the given число of минуты.
         */
        static ИнтервалВремени изМин(дол значение)
        {
                return ИнтервалВремени(ТиковВМин * значение);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of часы
         *
         * Параметры: значение = The число of часы.
         * Возвращает: A ИнтервалВремени representing the given число of часы.
         */
        static ИнтервалВремени изЧасов(дол значение)
        {
                return ИнтервалВремени(ТиковВЧас * значение);
        }

        /**
         * Construct a ИнтервалВремени из_ the given число of дни
         *
         * Параметры: значение = The число of дни.
         * Возвращает: A ИнтервалВремени representing the given число of дни.
         */
        static ИнтервалВремени изДней(дол значение)
        {
                return ИнтервалВремени(ТиковВДень * значение);
        }

        /**
         * Construct a ИнтервалВремени из_ the given интервал.  The интервал
         * represents сек as a дво.  This allows Всё whole и
         * fractional сек в_ be passed in.
         *
         * Параметры: значение = The интервал в_ преобразуй in сек.
         * Возвращает: A ИнтервалВремени representing the given интервал.
         */
        static ИнтервалВремени изИнтервала(дво sec)
        {
                return ИнтервалВремени(cast(дол)(sec * ТиковВСек + .1));
        }
		
		//+++++++++++++++++++++++
		/+
		цел часы()
		{
		return cast(цел)((тики_ / ТиковВЧас) % 24);
		}
		
		цел минуты() {
			return cast(цел)((тики_ / ТиковВМин) % 60);
		}
		
		цел секунды()() {
		return cast(цел)((тики_ / ТиковВСек) % 60);
		}
		
		 цел миллисекунды() {
		return cast(цел)((тики_ / ТиковВМиллисек) % 1000);
		}
		+/
		дво всегоМиллисек() {
		return cast(дво)тики_ * МиллисекНаТик;
		}
		
		дво всегоСек() {
		return cast(дво)тики_ * СекНаТик;
		}

		дво всегоМин() {
			return cast(дво)тики_ * МинутНаТик;
		}
/+
		  /// Gets the _days component.
		цел дни() {
			return cast(цел)(тики_ / ТиковВДень);
		}
		
		
	static ИнтервалВремени интервал(дво значение, цел scale) {
    дво d = значение * scale;
    дво millis = d + (значение >= 0 ? 0.5 : -0.5);
    return ИнтервалВремени(cast(дол)millis * ТиковВМиллисек);
  }

  /// Returns a ИнтервалВремени representing a specified number of seconds.
  static ИнтервалВремени изСек(дво значение) {
    return интервал(значение, МиллисекВСек);
  }

  /// Returns a ИнтервалВремени representing a specified number of milliseconds.
  static ИнтервалВремени изМиллисек(дво значение) {
    return интервал(значение, 1);
  }
+/
  /**
   * Compares two ИнтервалВремени values and returns an integer indicating whether the first is shorter than, equal to, or longer than the second.
   * Возвращает: -1 if t1 is shorter than t2; 0 if t1 equals t2; 1 if t1 is longer than t2.
   */
  static цел сравни(ИнтервалВремени t1, ИнтервалВремени t2) {
    if (t1.тики_ > t2.тики_)
      return 1;
    else if (t1.тики_ < t2.тики_)
      return -1;
    return 0;
  }

  /**
   * Compares this instance to a specified ИнтервалВремени and returns an integer indicating whether the first is shorter than, equal to, or longer than the second.
   * Возвращает: -1 if t1 is shorter than t2; 0 if t1 equals t2; 1 if t1 is longer than t2.
   */
  цел сравниС(ИнтервалВремени другой) {
    if (тики_ > другой.тики_)
      return 1;
    else if (тики_ < другой.тики_)
      return -1;
    return 0;
  }

  /**
   * Returns a значение indicating whether two instances are equal.
   * Параметры:
   *   t1 = The first ИнтервалВремени.
   *   t2 = The seconds ИнтервалВремени.
   * Возвращает: true if the values of t1 and t2 are equal; otherwise, false.
   */
  static бул равны(ИнтервалВремени t1, ИнтервалВремени t2) {
    return t1.тики_ == t2.тики_;
  }

  /**
   * Returns a значение indicating whether this instance is equal to another.
   * Параметры: другой = An ИнтервалВремени to сравни with this instance.
   * Возвращает: true if другой represents the same time интервал as this instance; otherwise, false.
   */
  бул равен(ИнтервалВремени другой) {
    return тики_ == другой.тики_;
  }

  бцел вХэш() {
    return cast(цел)тики_ ^ cast(цел)(тики_ >> 32);
  }

  /// Returns a string representation of the значение of this instance.
  ткст вТкст() {
    ткст s;

    цел day = cast(цел)(тики_ / ТиковВДень);
    дол time = тики_ % ТиковВДень;

    if (тики_ < 0) {
      s ~= "-";
      day = -day;
      time = -time;
    }
    if (day != 0) {
      s ~= фм("%d", day);
      s ~= ".";
    }
    s ~= фм("%0.2d", cast(цел)((time / ТиковВЧас) % 24));
    s ~= ":";
    s ~= фм("%0.2d", cast(цел)((time / ТиковВМин) % 60));
    s ~= ":";
    s ~= фм("%0.2d", cast(цел)((time / ТиковВСек) % 60));

    цел frac = cast(цел)(time % ТиковВСек);
    if (frac != 0) {
      s ~= ".";
      s ~= фм("%0.7d", frac);
    }

    return s;
  }

  /// Adds the specified ИнтервалВремени to this instance.
  ИнтервалВремени прибавь(ИнтервалВремени ts) {
    return ИнтервалВремени(тики_ + ts.тики_);
  }

 /// ditto
  void opAddAssign(ИнтервалВремени ts) {
    тики_ += ts.тики_;
  }

  /// Subtracts the specified ИнтервалВремени from this instance.
  ИнтервалВремени отними(ИнтервалВремени ts) {
    return ИнтервалВремени(тики_ - ts.тики_);
  }

  /// ditto
  void opSubAssign(ИнтервалВремени ts) {
    тики_ -= ts.тики_;
  }

  /// Returns a ИнтервалВремени whose значение is the negated значение of this instance.
  ИнтервалВремени дайНегатив() {
    return ИнтервалВремени(-тики_);
  }

  ИнтервалВремени opPos() {
      return *this;
    
  }
		
}


/******************************************************************************

        Represents a точка in время.

        Remarks: Время represents dates и times between 12:00:00 
        mопрnight on January 1, 10000 BC и 11:59:59 PM on December 31, 
        9999 AD.

        Время значения are measured in 100-nanosecond intervals, or тики. 
        A дата значение is the число of тики that have elapsed since 
        12:00:00 mопрnight on January 1, 0001 AD in the Грегориан 
        Календарь.
        
        Negative Время значения are offsets из_ that same reference точка, 
        but backwards in history.  Время значения are not specific в_ any 
        Календарь, but for an example, the beginning of December 31, 1 BC 
        in the Грегориан Календарь is Время.эпоха - ИнтервалВремени.дни(1).

******************************************************************************/

struct Время 
{
        private дол тики_;

        private enum : дол
        {
                максимум = (ИнтервалВремени.ДнейНа400Лет * 25 - 366) * ИнтервалВремени.ТиковВДень - 1,
                минимум = -((ИнтервалВремени.ДнейНа400Лет * 25 - 366) * ИнтервалВремени.ТиковВДень - 1),
        }

        /// Represents the smallest и largest Время значение.
        static const Время мин       = {минимум},
                          макс       = {максимум};

        /// Represents the эпоха (1/1/0001)
        static const Время эпоха     = {0};

        /// Represents the эпоха of 1/1/1601 (Commonly использован in Windows systems)
        static const Время эпоха1601 = {ИнтервалВремени.Эпоха1601};

        /// Represents the эпоха of 1/1/1970 (Commonly использован in Unix systems)
        static const Время эпоха1970 = {ИнтервалВремени.Эпоха1970};

        /**********************************************************************

                $(I Property.) Retrieves the число of тики for this Время.
                This значение can be использован в_ construct другой Время struct by
                writing:

                ---------
                дол тики = myTime.тики;
                Время copyOfMyTime = Время(тики);
                ---------


                Возвращает: A дол represented by the время of this 
                         экземпляр.

        **********************************************************************/

        дол тики ()
        {
                return тики_;
        }

        /**********************************************************************

                Determines whether two Время значения are equal.

                Параметры:  значение = A Время _value.
                Возвращает: да if Всё экземпляры are equal; otherwise, нет

        **********************************************************************/

        цел opEquals (Время t) 
        {
                return тики_ is t.тики_;
        }

        /**********************************************************************

                Compares two Время значения.

        **********************************************************************/

        цел opCmp (Время t) 
        {
                if (тики_ < t.тики_)
                    return -1;

                if (тики_ > t.тики_)
                    return 1;

                return 0;
        }

        /**********************************************************************

                добавьs the specified время вринтервал в_ the время, returning a new
                время.
                
                Параметры:  t = A ИнтервалВремени значение.
                Возвращает: A Время that is the sum of this экземпляр и t.

        **********************************************************************/

        Время opAdd (ИнтервалВремени t) 
        {
                return Время (тики_ + t.тики_);
        }

        /**********************************************************************

                добавьs the specified время вринтервал в_ the время, assigning 
                the результат в_ this экземпляр.

                Параметры:  t = A ИнтервалВремени значение.
                Возвращает: The текущ Время экземпляр, with t добавьed в_ the 
                         время.

        **********************************************************************/

        Время opAddAssign (ИнтервалВремени t) 
        {
                тики_ += t.тики_;
                return *this;
        }

        /**********************************************************************

                Subtracts the specified время вринтервал из_ the время, 
                returning a new время.

                Параметры:  t = A ИнтервалВремени значение.
                Возвращает: A Время whose значение is the значение of this экземпляр 
                         minus the значение of t.

        **********************************************************************/

        Время opSub (ИнтервалВремени t) 
        {
                return Время (тики_ - t.тики_);
        }

        /**********************************************************************

                Returns a время вринтервал which represents the difference in время
                between this и the given Время.

                Параметры:  t = A Время значение.
                Возвращает: A ИнтервалВремени which represents the difference between
                         this и t.

        **********************************************************************/

        ИнтервалВремени opSub (Время t)
        {
                return ИнтервалВремени(тики_ - t.тики_);
        }

        /**********************************************************************

                Subtracts the specified время вринтервал из_ the время, 
                assigning the результат в_ this экземпляр.

                Параметры:  t = A ИнтервалВремени значение.
                Возвращает: The текущ Время экземпляр, with t subtracted 
                         из_ the время.

        **********************************************************************/

        Время opSubAssign (ИнтервалВремени t) 
        {
                тики_ -= t.тики_;
                return *this;
        }

        /**********************************************************************

                $(I Property.) Retrieves the дата component.

                Возвращает: A new Время экземпляр with the same дата as 
                         this экземпляр, but with the время truncated.

        **********************************************************************/

        Время дата () 
        {
                return *this - ВремяДня.модуль24(тики_);
        }

        /**********************************************************************

                $(I Property.) Retrieves the время of день.

                Возвращает: A ВремяДня representing the дво of the день 
                         elapsed since mопрnight.

        **********************************************************************/

        ВремяДня время () 
        {
                return ВремяДня (тики_);
        }

        /**********************************************************************

                $(I Property.) Retrieves the equivalent ИнтервалВремени.

                Возвращает: A ИнтервалВремени representing this Время.

        **********************************************************************/

        ИнтервалВремени вринтервал () 
        {
                return ИнтервалВремени (тики_);
        }

        /**********************************************************************

                $(I Property.) Retrieves a ИнтервалВремени that corresponds в_ Unix
                время (время since 1/1/1970).  Use the ИнтервалВремени accessors в_ получи
                the время in сек, milliseconds, etc.

                Возвращает: A ИнтервалВремени representing this Время as Unix время.

                -------------------------------------
                auto unixTime = Часы.сейчас.unix.сек;
                auto javaTime = Часы.сейчас.unix.миллисек;
                -------------------------------------

        **********************************************************************/

        ИнтервалВремени юникс()
        {
                return ИнтервалВремени(тики_ - эпоха1970.тики_);
        }
}


/******************************************************************************

        Represents a время of день. This is different из_ ИнтервалВремени in that 
        each component is represented внутри the limits of everyday время, 
        rather than из_ the старт of the Эпоха. Effectively, the ВремяДня
        эпоха is the первый секунда of each день.

        This is handy for dealing strictly with a 24-час clock instead of
        potentially thousands of годы. For example:
        ---
        auto время = Часы.сейчас.время;
        assert (время.миллисек < 1000);
        assert (время.сек < 60);
        assert (время.минуты < 60);
        assert (время.часы < 24);
        ---

        You can создай a ВремяДня из_ an existing Время or ИнтервалВремени экземпляр
        via the respective время() метод. To преобразуй back в_ a ИнтервалВремени, use
        the вринтервал() метод

******************************************************************************/

struct ВремяДня 
{
        /**
         * часы component of the время of день.  This should be between 0 и
         * 23, включительно.
         */
        public бцел     часы;

        /**
         * минуты component of the время of день.  This should be between 0 и
         * 59, включительно.
         */
        public бцел     минуты;

        /**
         * сек component of the время of день.  This should be between 0 и
         * 59, включительно.
         */
        public бцел     сек;

        /**
         * milliseconds component of the время of день.  This should be between
         * 0 и 999, включительно.
         */
        public бцел     миллисек;

        /**
         * constructor.
         * Параметры: часы = число of часы since mопрnight
         *         минуты = число of минуты преобр_в the час
         *         сек = число of сек преобр_в the минута
         *         миллисек = число of milliseconds преобр_в the секунда
         *
         * Возвращает: a ВремяДня representing the given время fields.
         *
         * Note: There is no verification of the range of значения, or
         * normalization made.  So if you пароль in larger значения than the
         * максимум значение for that field, they will be stored as that значение.
         *
         * example:
         * --------------
         * auto tod = ВремяДня(100, 100, 100, 10000);
         * assert(tod.часы == 100);
         * assert(tod.минуты == 100);
         * assert(tod.сек == 100);
         * assert(tod.миллисек == 10000);
         * --------------
         */
        static ВремяДня opCall (бцел часы, бцел минуты, бцел сек, бцел миллисек=0)
        {
                ВремяДня t =void;
                t.часы   = часы;
                t.минуты = минуты;
                t.сек = сек;
                t.миллисек  = миллисек;
                return t;
        }

        /**
         * constructor.
         * Параметры: тики = тики representing a Время значение.  This is normalized 
         * so that it represent a время of день (modulo-24 etc)
         *
         * Возвращает: a ВремяДня значение that corresponds в_ the время of день of
         * the given число of тики.
         */
        static ВремяДня opCall (дол тики)
        {       
                ВремяДня t =void;
                тики = модуль24(тики).тики_;
                t.миллисек  = cast(бцел) (тики / ИнтервалВремени.ТиковВМиллисек); 
                t.сек = (t.миллисек / 1_000) % 60;
                t.минуты = (t.миллисек / 60_000) % 60;
                t.часы   = (t.миллисек / 3_600_000) % 24;
                t.миллисек %= 1000;
                return t;
        }

        /**
         * construct a ИнтервалВремени из_ the текущ fields
         *
         * Возвращает: a ВремяДня representing the field значения.
         *
         * Note: that fields are not проверьed against a действителен range, so
         * настройка 60 for минуты is allowed, и will just добавь 1 в_ the час
         * component, и установи the минута component в_ 0.  The результат is
         * normalized, so the часы wrap.  If you пароль in 25 часы, the
         * resulting ВремяДня will have a час component of 1.
         */
        ИнтервалВремени вринтервал ()
        {
                return ИнтервалВремени.изЧасов(часы) +
                       ИнтервалВремени.изМин(минуты) + 
                       ИнтервалВремени.изСек(сек) + 
                       ИнтервалВремени.изМиллисек(миллисек);
        }

        /**
         * internal routine в_ исправь тики by one день. Also adjusts for
         * offsets in the BC эра
         */
         static ИнтервалВремени модуль24 (дол тики)
        {
                тики %= ИнтервалВремени.ТиковВДень;
                if (тики < 0)
                    тики += ИнтервалВремени.ТиковВДень;
                return ИнтервалВремени (тики);
        }
}

/******************************************************************************

    Generic Дата representation

******************************************************************************/

struct Дата
{
        public бцел         эра,            /// AD, BC
                            день,            /// 1 .. 31
                            год,           /// 0 в_ 9999
                            месяц,          /// 1 .. 12
                            деньнед,            /// 0 .. 6
                            деньгода;            /// 1 .. 366
}


/******************************************************************************

    Combination of a Дата и a ВремяДня

******************************************************************************/

struct ДатаВремя
{
        public Дата         дата;       /// дата representation
        public ВремяДня    время;       /// время representation
}




/******************************************************************************

******************************************************************************/

debug (UnitTest)
{
        unittest
        {
                assert(ИнтервалВремени.нуль > ИнтервалВремени.мин);
                assert(ИнтервалВремени.макс  > ИнтервалВремени.нуль);
                assert(ИнтервалВремени.макс  > ИнтервалВремени.мин);
                assert(ИнтервалВремени.нуль >= ИнтервалВремени.нуль);
                assert(ИнтервалВремени.нуль <= ИнтервалВремени.нуль);
                assert(ИнтервалВремени.макс >= ИнтервалВремени.макс);
                assert(ИнтервалВремени.макс <= ИнтервалВремени.макс);
                assert(ИнтервалВремени.мин >= ИнтервалВремени.мин);
                assert(ИнтервалВремени.мин <= ИнтервалВремени.мин);

                assert (ИнтервалВремени.изСек(50).сек is 50);
                assert (ИнтервалВремени.изСек(5000).сек is 5000);
                assert (ИнтервалВремени.изМин(50).минуты is 50);
                assert (ИнтервалВремени.изМин(5000).минуты is 5000);
                assert (ИнтервалВремени.изЧасов(23).часы is 23);
                assert (ИнтервалВремени.изЧасов(5000).часы is 5000);
                assert (ИнтервалВремени.изДней(6).дни is 6);
                assert (ИнтервалВремени.изДней(5000).дни is 5000);

                assert (ИнтервалВремени.изСек(50).время.сек is 50);
                assert (ИнтервалВремени.изСек(5000).время.сек is 5000 % 60);
                assert (ИнтервалВремени.изМин(50).время.минуты is 50);
                assert (ИнтервалВремени.изМин(5000).время.минуты is 5000 % 60);
                assert (ИнтервалВремени.изЧасов(23).время.часы is 23);
                assert (ИнтервалВремени.изЧасов(5000).время.часы is 5000 % 24);

                auto tod = ВремяДня (25, 2, 3, 4);
                tod = tod.вринтервал.время;
                assert (tod.часы is 1);
                assert (tod.минуты is 2);
                assert (tod.сек is 3);
                assert (tod.миллисек is 4);
        }
}


/*******************************************************************************

*******************************************************************************/

debug (Time)
{
        import io.Stdout;
        import time.Clock;
        import time.chrono.Gregorian;

        Время foo() 
        {
                auto d = Время(10);
                auto e = ИнтервалВремени(20);

                return d + e;
        }

        проц main()
        {
                auto c = foo();
                Стдвыв (c.тики).нс;


                auto t = ИнтервалВремени(1);
                auto h = t.часы;
                auto m = t.время.минуты;

                auto сейчас = Часы.сейчас;
                auto время = сейчас.время;
                auto дата = Грегориан.генерный.вДату (сейчас);
                сейчас = Грегориан.генерный.воВремя (дата, время);
        }
}

