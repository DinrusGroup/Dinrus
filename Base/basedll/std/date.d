
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

module std.date;
import  sys.WinStructs, std.string;


export extern(D)
{

      Дата разборДаты(ткст т)
      {  
      РазборДаты dp;
      Дата д;
      dp.parse(т, д);
           return  д;
      }


       struct Дата
      {
      export:
          цел год;    /// use цел.min as "nan" year значение
          цел месяц;      /// 1..12
          цел день;       /// 1..31
          цел час;        /// 0..23
          цел минута;     /// 0..59
          цел секунда;        /// 0..59
          цел мс;     /// 0..999
          цел день_недели;    /// 0: not specified, 1..7: Sunday..Saturday
          цел коррекцияЧП;    /// -1200..1200 correction in hours

          /// Разбор даты из текста т[] и сохранение её как экземпляра Даты.

          проц разбор(ткст т)
          {
              Дата а = разборДаты(т);
              год = а.год;    /// use цел.min as "nan" year значение
              месяц = а.месяц;        /// 1..12
              день =а.день;       /// 1..31
              час =а.час;     /// 0..23
              минута = а.минута;      /// 0..59
              секунда = а.секунда;        /// 0..59
              мс = а.мс;      /// 0..999
              день_недели = а.день_недели;    /// 0: not specified, 1..7: Sunday..Saturday
              коррекцияЧП = а.коррекцияЧП;
          }

      }


      enum
      {
      	ЧасовВДне    = 24,
      	МинутВЧасе = 60,
      	МсекВМинуте    = 60 * 1000,
      	МсекВЧасе      = 60 * МсекВМинуте,
      	МсекВДень       = 86400000,
      	ТиковВМсек     = 1,
      	ТиковВСекунду = 1000,			/// Will be at least 1000
      	ТиковВМинуту = ТиковВСекунду * 60,
      	ТиковВЧас   = ТиковВМинуту * 60,
      	ТиковВДень    = ТиковВЧас  * 24,
      }

      т_время ЛокЧПП = cast(т_время) 0;


      const char[] стрдней = "SunMonTueWedThuFriSatВсПнВтСрЧтПтСб";
      const char[] стрмес = "JanFebMarAprMayJunJulAugSepOctNovDec";

      const int[12] mdays = [ 0,31,59,90,120,151,181,212,243,273,304,334 ];



      проц  вГодНедИСО8601(т_время t, out цел год, out цел неделя)
      {
       toISO8601YearWeek(t, год, неделя);
      }

      цел день(т_время t) 
      {
          return cast(цел)floor(t, 86400000);
           }

      цел високосныйГод(цел y)
          {
              return ((y & 3) == 0 &&
                  (y % 100 || (y % 400) == 0));
          }

      цел днейВГоду(цел y)
          {  
               return 365 + LeapYear(y);  
                 }

      цел деньИзГода(цел y) 
        {     
          return DayFromYear(y);  
         }

      т_время времяИзГода(цел y)
        {   
            return cast(т_время) (msPerDay * DayFromYear(y));
            }

      цел год(т_время t)  
        {
          return YearFromTime(cast(т_время) t);
      }

      бул високосный_ли(т_время t)
          {
              if(LeapYear(YearFromTime(cast(т_время) t)) != 0)
              return да;
              else return нет;
          }

      цел месяц(т_время t)
          {
              return MonthFromTime(cast(т_время) t);
             }

      цел дата(т_время t)  
       {
          return DateFromTime(cast(т_время) t); 
             }

      т_время нокругли(т_время d, цел делитель) 
        { 
          return cast(т_время) floor(cast(т_время) d, делитель);   
               }

      цел дмод(т_время n, т_время d)
        { 
          return dmod(n,d);  
            }

      цел час(т_время t)   
       {   
           return dmod(floor(t, msPerHour), HoursPerDay);  
         }

      цел минута(т_время t)  
        {   
            return dmod(floor(t, msPerMinute), MinutesPerHour);  
             }

      цел секунда(т_время t) 
         {   
             return dmod(floor(t, TicksPerSecond), 60);  
               }

      цел мсекИзВрем(т_время t) 
        {     
          return dmod(t / (TicksPerSecond / 1000), 1000); 
           }

      цел времениВДне(т_время t) 
       {   
           return dmod(t, msPerDay);  
             }

      цел деньНедели(т_время вр)
      {
          return WeekDay(вр);
      }

      т_время МВ8Местное(т_время вр)
      {
          return cast(т_время) UTCtoLocalTime(вр);
      }

      т_время местное8МВ(т_время вр)
      {
          return cast(т_время) LocalTimetoUTC(вр);
      }

      т_время сделайВремя(т_время час, т_время мин, т_время сек, т_время мс)
      {
          return cast(т_время) MakeTime(час, мин, сек, мс);
      }

      т_время сделайДень(т_время год, т_время месяц, т_время дата)
      {
          return cast(т_время) MakeDay(год, месяц, дата);
      }

      т_время сделайДату(т_время день, т_время вр)
      {
          return cast(т_время) MakeDate(день, вр);
      }
      //т_время TimeClip(т_время время)
      цел датаОтДняНеделиМесяца(цел год, цел месяц, цел день_недели, цел ч)
      {
          return  DateFromNthWeekdayOfMonth(год, месяц, день_недели, ч);
      }

      цел днейВМесяце(цел год, цел месяц)
      {
          return DaysInMonth(год, месяц);
      }

      ткст вТкст(т_время время)
      {
          return toString(время);
      }

      ткст вТкстМВ(т_время время)
      {
          return toUTCString(время);
      }

      ткст вТкстДаты(т_время время)
      {
          return toDateString(время);
      }

      ткст вТкстВремени(т_время время)
      {
          return toTimeString(время);
      }

      т_время разборВремени(ткст т)
      {
          return cast(т_время) parse(т);
      }

      т_время дайВремяМВ()
      {
          return cast(т_время) getUTCtime();
      }

      т_время ФВРЕМЯ8т_время(ФВРЕМЯ *фв)
      {
          return cast(т_время) FILETIME2d_time(фв);
      }

      т_время СИСТВРЕМЯ8т_время(СИСТВРЕМЯ *св, т_время вр)
      {return cast(т_время) SYSTEMTIME2d_time(св,cast(дол) вр);
      }

      т_время дайМестнуюЗЧП()
      {
          return cast(т_время) дайЛокTZA();
      }

      цел дневноеСохранениеЧО(т_время вр)
      {
          return DaylightSavingTA(вр);
      }

      т_время вДвремя(ФВремяДос вр)
      {
          return cast(т_время) cast(дол) toDtime( cast(DosFileTime) вр);
      }

      ФВремяДос вФВремяДос(т_время вр)
      {
          return cast(ФВремяДос) toDosFileTime(вр);
      }

      ткст ДАТА()
      {
      СИСТВРЕМЯ систВремя;
      ДайМестнВремя(&систВремя);
      ткст ДАТА = std.string.вТкст(систВремя.день)~"."~std.string.вТкст(систВремя.месяц)~"."~std.string.вТкст(систВремя.год);
      return  ДАТА;
      }

      ткст ВРЕМЯ()
      {
      СИСТВРЕМЯ систВремя;
      ДайМестнВремя(&систВремя);
      ткст ВРЕМЯ = std.string.вТкст(систВремя.час)~" ч. "~std.string.вТкст(систВремя.минута)~" мин.";
      return  ВРЕМЯ;
      }

}


////////////////////////////////////////////////

void toISO8601YearWeek(т_время t, out int year, out int week)
{
    year = YearFromTime(t);

    int yday = Day(t) - DayFromYear(year);
    int d;
    int w;
    int ydaybeg;

    /* Determine day of week Jan 4 falls on.
     * Weeks begin on a Monday.
     */

    d = DayFromYear(year);
    w = (d + 3/*Jan4*/ + 3) % 7;
    if (w < 0)
        w += 7;

    /* Find yday of beginning of ISO 8601 year
     */
    ydaybeg = 3/*Jan4*/ - w;

    /* Check if yday is actually the last week of the previous year
     */
    if (yday < ydaybeg)
    {
  year -= 1;
  week = 53;
        return;
    }

    /* Check if yday is actually the first week of the следщ year
     */
    if (yday >= 362)                            // possible
    {   int d2;
        int ydaybeg2;

        d2 = DayFromYear(year + 1);
        w = (d2 + 3/*Jan4*/ + 3) % 7;
        if (w < 0)
            w += 7;
        //эхо("w = %d\n", w);
        ydaybeg2 = 3/*Jan4*/ - w;
        if (d + yday >= d2 + ydaybeg2)
        {
      year += 1;
      week = 1;
            return;
        }
    }

    week = (yday - ydaybeg) / 7 + 1;
}

/* ***********************************
 * Divide time by divisor. Always round down, even if d is negative.
 */

т_время нокругли(т_время d, цел делитель)
  {
  return floor(d, делитель);
  }

цел дмод(т_время n, т_время d)
  {   return dmod(n,d);
  }

т_время floor(т_время d, int divisor)
{
    if (d < 0)
  d -= divisor - 1;
    return d / divisor;
}

int dmod(т_время n, т_время d)
{   т_время r;

    r = n % d;
    if (r < 0)
  r += d;
    assert(cast(int)r == r);
    return cast(int)r;
}

цел часИзВрем(т_время t)
  {
    return dmod(floor(t, msPerHour), HoursPerDay);
  }

цел минИзВрем(т_время t)
  {
    return dmod(floor(t, msPerMinute), MinutesPerHour);
  }

цел секИзВрем(т_время t)
  {
    return dmod(floor(t, TicksPerSecond), 60);
  }

цел мсекИзВрем(т_время t)
  {
    return dmod(t / (TicksPerSecond / 1000), 1000);
  }

int HourFromTime(т_время t)
{
    return dmod(floor(t, msPerHour), HoursPerDay);
}

int MinFromTime(т_время t)
{
    return dmod(floor(t, msPerMinute), MinutesPerHour);
}

int SecFromTime(т_время t)
{
    return dmod(floor(t, TicksPerSecond), 60);
}

int msFromTime(т_время t)
{
    return dmod(t / (TicksPerSecond / 1000), 1000);
}

int TimeWithinDay(т_время t)
{
    return dmod(t, msPerDay);
}


т_время toInteger(т_время n)
{
    return n;
}


int Day(т_время t)
{
    return cast(int)floor(t, msPerDay);
}

int LeapYear(int y)
{
    return ((y & 3) == 0 &&
      (y % 100 || (y % 400) == 0));
}

int DaysInYear(int y)
{
    return 365 + LeapYear(y);
}

int DayFromYear(int y)
{
    return cast(int) (365 * (y - 1970) +
    floor((y - 1969), 4) -
    floor((y - 1901), 100) +
    floor((y - 1601), 400));
}

т_время TimeFromYear(int y)
{
    return cast(т_время)msPerDay * DayFromYear(y);
}

/*****************************
 * Calculates the year from the т_время t.
 */

int YearFromTime(т_время t)
{   int y;

    if (t == d_time_nan)
  return 0;

    // Hazard a guess
    //y = 1970 + cast(int) (t / (365.2425 * msPerDay));
    // Use integer only math
    y = 1970 + cast(int) (t / (3652425 * (msPerDay / 10000)));

    if (TimeFromYear(y) <= t)
    {
  while (TimeFromYear(y + 1) <= t)
      y++;
    }
    else
    {
  do
  {
      y--;
  }
  while (TimeFromYear(y) > t);
    }
    return y;
}

/*******************************
 * Determines if т_время t is a leap year.
 *
 * A leap year is every 4 years except years ending in 00 that are not
 * divsible by 400.
 *
 * Returns: !=0 if it is a leap year.
 *
 * References:
 *  $(LINK2 http://en.wikipedia.org/wiki/Leap_year, Wikipedia)
 */

int inLeapYear(т_время t)
{
    return LeapYear(YearFromTime(t));
}

/*****************************
 * Calculates the month from the т_время t.
 *
 * Returns: Integer in the range 0..11, where
 *  0 represents January and 11 represents December.
 */

int MonthFromTime(т_время t)
{
    int day;
    int month;
    int year;

    year = YearFromTime(t);
    day = Day(t) - DayFromYear(year);

    if (day < 59)
    {
  if (day < 31)
  {   assert(day >= 0);
      month = 0;
  }
  else
      month = 1;
    }
    else
    {
  day -= LeapYear(year);
  if (day < 212)
  {
      if (day < 59)
    month = 1;
      else if (day < 90)
    month = 2;
      else if (day < 120)
    month = 3;
      else if (day < 151)
    month = 4;
      else if (day < 181)
    month = 5;
      else
    month = 6;
  }
  else
  {
      if (day < 243)
    month = 7;
      else if (day < 273)
    month = 8;
      else if (day < 304)
    month = 9;
      else if (day < 334)
    month = 10;
      else if (day < 365)
    month = 11;
      else
    assert(0);
  }
    }
    return month;
}

/*******************************
 * Compute which day in a month a т_время t is.
 * Returns:
 *  Integer in the range 1..31
 */
int DateFromTime(т_время t)
{
    int day;
    int leap;
    int month;
    int year;
    int дата;

    year = YearFromTime(t);
    day = Day(t) - DayFromYear(year);
    leap = LeapYear(year);
    month = MonthFromTime(t);
    switch (month)
    {
  case 0:  дата = day +   1;    break;
  case 1:  дата = day -  30;    break;
  case 2:  дата = day -  58 - leap; break;
  case 3:  дата = day -  89 - leap; break;
  case 4:  дата = day - 119 - leap; break;
  case 5:  дата = day - 150 - leap; break;
  case 6:  дата = day - 180 - leap; break;
  case 7:  дата = day - 211 - leap; break;
  case 8:  дата = day - 242 - leap; break;
  case 9:  дата = day - 272 - leap; break;
  case 10: дата = day - 303 - leap; break;
  case 11: дата = day - 333 - leap; break;
  default:
      assert(0);
    }
    return дата;
}

/*******************************
 * Compute which day of the week a т_время t is.
 * Returns:
 *  Integer in the range 0..6, where 0 represents Sunday
 *  and 6 represents Saturday.
 */
int WeekDay(т_время t)
{   int w;

    w = (cast(int)Day(t) + 4) % 7;
    if (w < 0)
  w += 7;
    return w;
}

/***********************************
 * Convert from UTC to local time.
 */

т_время UTCtoLocalTime(т_время t)
{
    return (t == d_time_nan)
  ? d_time_nan
  : t + LocalTZA + DaylightSavingTA(t);
}

/***********************************
 * Convert from local time to UTC.
 */

т_время LocalTimetoUTC(т_время t)
{
    return (t == d_time_nan)
  ? d_time_nan
/* BUGZILLA 1752 says this line should be:
 *  : t - LocalTZA - DaylightSavingTA(t);
 */
  : t - LocalTZA - DaylightSavingTA(t - LocalTZA);
}


т_время MakeTime(т_время hour, т_время min, т_время sec, т_время ms)
{
    return hour * TicksPerHour +
     min * ТиковВМинуту +
     sec * TicksPerSecond +
     ms * TicksPerMs;
}

/* *****************************
 * Параметры:
 *  month = 0..11
 *  дата = day of month, 1..31
 * Returns:
 *  number of days since start of epoch
 */

т_время MakeDay(т_время year, т_время month, т_время дата)
{   т_время t;
    int y;
    int m;
    int leap;

    y = cast(int)(year + floor(month, 12));
    m = dmod(month, 12);

    leap = LeapYear(y);
    t = TimeFromYear(y) + cast(т_время)mdays[m] * msPerDay;
    if (leap && month >= 2)
  t += msPerDay;

    if (YearFromTime(t) != y ||
  MonthFromTime(t) != m ||
  DateFromTime(t) != 1)
    {
  return  d_time_nan;
    }

    return Day(t) + дата - 1;
}

т_время MakeDate(т_время day, т_время time)
{
    if (day == d_time_nan || time == d_time_nan)
  return d_time_nan;

    return day * TicksPerDay + time;
}

т_время TimeClip(т_время time)
{
    //эхо("TimeClip(%g) = %g\n", time, toInteger(time));

    return toInteger(time);
}

/***************************************
 * Determine the дата in the month, 1..31, of the nth
 * weekday.
 * Параметры:
 *  year = year
 *  month = month, 1..12
 *  weekday = day of week 0..6 representing Sunday..Saturday
 *  n = nth occurrence of that weekday in the month, 1..5, where
 *      5 also means "the last occurrence in the month"
 * Returns:
 *  the дата in the month, 1..31, of the nth weekday
 */

int DateFromNthWeekdayOfMonth(int year, int month, int weekday, int n)
in
{
    assert(1 <= month && month <= 12);
    assert(0 <= weekday && weekday <= 6);
    assert(1 <= n && n <= 5);
}
body
{
    // Get day of the first of the month
    auto x = MakeDay(year, month - 1, 1);

    // Get the week day 0..6 of the first of this month
    auto wd = WeekDay(MakeDate(x, 0));

    // Get monthday of first occurrence of weekday in this month
    auto mday = weekday - wd + 1;
    if (mday < 1)
  mday += 7;

    // Add in number of weeks
    mday += (n - 1) * 7;

    // If monthday is more than the number of days in the month,
    // back up to 'last' occurrence
    if (mday > 28 && mday > DaysInMonth(year, month))
    { assert(n == 5);
  mday -= 7;
    }

    return mday;
}

unittest
{
    assert(DateFromNthWeekdayOfMonth(2003,  3, 0, 5) == 30);
    assert(DateFromNthWeekdayOfMonth(2003, 10, 0, 5) == 26);
    assert(DateFromNthWeekdayOfMonth(2004,  3, 0, 5) == 28);
    assert(DateFromNthWeekdayOfMonth(2004, 10, 0, 5) == 31);
}

/**************************************
 * Determine the number of days in a month, 1..31.
 * Параметры:
 *  month = 1..12
 */

int DaysInMonth(int year, int month)
{
    switch (month)
    {
  case 1:
  case 3:
  case 5:
  case 7:
  case 8:
  case 10:
  case 12:
      return 31;
  case 2:
      return 28 + LeapYear(year);
  case 4:
  case 6:
  case 9:
  case 11:
      return 30;
  default:
      assert(0);
    }
}

unittest
{
    assert(DaysInMonth(2003, 2) == 28);
    assert(DaysInMonth(2004, 2) == 29);
}

/*************************************
 * Converts UTC time into a text string of the form:
 * "Www Mmm dd hh:mm:ss GMT+-TZ yyyy".
 * For example, "Tue Apr 02 02:04:57 GMT-0800 1996".
 * If time is invalid, i.e. is d_time_nan,
 * the string "Invalid дата" is returned.
 *
 * Example:
 * ------------------------------------
  т_время lNow;
  char[] lNowString;

  // Grab the дата and time relative to UTC
  lNow = getUTCtime();
  // Convert this into the local дата and time for display.
  lNowString = toString(lNow);
 * ------------------------------------
 */

string toString(т_время time)
{
    т_время t;
    char sign;
    int hr;
    int mn;
    int len;
    т_время offset;
    т_время dst;

    // Years are supposed to be -285616 .. 285616, or 7 digits
    // "Tue Apr 02 02:04:57 GMT-0800 1996"
    char[] buffer = new char[29 + 7 + 1];

    if (time == d_time_nan)
  return "Неверная дата";

    dst = DaylightSavingTA(time);
    offset = LocalTZA + dst;
    t = time + offset;
    sign = '+';
    if (offset < 0)
    { sign = '-';
//  offset = -offset;
  offset = -(LocalTZA + dst);
    }

    mn = cast(int)(offset / msPerMinute);
    hr = mn / 60;
    mn %= 60;

    //эхо("hr = %d, offset = %g, LocalTZA = %g, dst = %g, + = %g\n", hr, offset, LocalTZA, dst, LocalTZA + dst);

    len = sprintf(buffer.ptr, "%.3s %.3s %02d %02d:%02d:%02d GMT%c%02d%02d %d",
  &daystr[WeekDay(t) * 3],
  &monstr[MonthFromTime(t) * 3],
  DateFromTime(t),
  HourFromTime(t), MinFromTime(t), SecFromTime(t),
  sign, hr, mn,
  cast(long)YearFromTime(t));

    // Ensure no buggy buffer overflows
    //эхо("len = %d, buffer.length = %d\n", len, buffer.length);
    assert(len < buffer.length);

    return buffer[0 .. len];
}

/***********************************
 * Converts t into a text string of the form: "Www, dd Mmm yyyy hh:mm:ss UTC".
 * If t is invalid, "Invalid дата" is returned.
 */

string toUTCString(т_время t)
{
    // Years are supposed to be -285616 .. 285616, or 7 digits
    // "Tue, 02 Apr 1996 02:04:57 GMT"
    char[] buffer = new char[25 + 7 + 1];
    int len;

    if (t == d_time_nan)
  return "Invalid Дата";

    len = sprintf(buffer.ptr, "%.3s, %02d %.3s %d %02d:%02d:%02d UTC",
  &daystr[WeekDay(t) * 3], DateFromTime(t),
  &monstr[MonthFromTime(t) * 3],
  YearFromTime(t),
  HourFromTime(t), MinFromTime(t), SecFromTime(t));

    // Ensure no buggy buffer overflows
    assert(len < buffer.length);

    return buffer[0 .. len];
}

/************************************
 * Converts the дата portion of time into a text string of the form: "Www Mmm dd
 * yyyy", for example, "Tue Apr 02 1996".
 * If time is invalid, "Invalid дата" is returned.
 */

string toDateString(т_время time)
{
    т_время t;
    т_время offset;
    т_время dst;
    int len;

    // Years are supposed to be -285616 .. 285616, or 7 digits
    // "Tue Apr 02 1996"
    char[] buffer = new char[29 + 7 + 1];

    if (time == d_time_nan)
  return "Invalid Дата";

    dst = DaylightSavingTA(time);
    offset = LocalTZA + dst;
    t = time + offset;

    len = sprintf(buffer.ptr, "%.3s %.3s %02d %d",
  &daystr[WeekDay(t) * 3],
  &monstr[MonthFromTime(t) * 3],
  DateFromTime(t),
  cast(long)YearFromTime(t));

    // Ensure no buggy buffer overflows
    assert(len < buffer.length);

    return buffer[0 .. len];
}

/******************************************
 * Converts the time portion of t into a text string of the form: "hh:mm:ss
 * GMT+-TZ", for example, "02:04:57 GMT-0800".
 * If t is invalid, "Invalid дата" is returned.
 * The input must be in UTC, and the output is in local time.
 */

string toTimeString(т_время time)
{
    т_время t;
    char sign;
    int hr;
    int mn;
    int len;
    т_время offset;
    т_время dst;

    // "02:04:57 GMT-0800"
    char[] buffer = new char[17 + 1];

    if (time == d_time_nan)
  return "Invalid Дата";

    dst = DaylightSavingTA(time);
    offset = LocalTZA + dst;
    t = time + offset;
    sign = '+';
    if (offset < 0)
    { sign = '-';
//  offset = -offset;
  offset = -(LocalTZA + dst);
    }

    mn = cast(int)(offset / msPerMinute);
    hr = mn / 60;
    mn %= 60;

    //эхо("hr = %d, offset = %g, LocalTZA = %g, dst = %g, + = %g\n", hr, offset, LocalTZA, dst, LocalTZA + dst);

    len = sprintf(buffer.ptr, "%02d:%02d:%02d GMT%c%02d%02d",
  HourFromTime(t), MinFromTime(t), SecFromTime(t),
  sign, hr, mn);

    // Ensure no buggy buffer overflows
    assert(len < buffer.length);

    // Lop off terminating 0
    return buffer[0 .. len];
}


/******************************************
 * Parses s as a textual дата string, and returns it as a т_время.
 * If the string is not a valid дата, d_time_nan is returned.
 */

т_время parse(string s)
{
    Дата dp;
    т_время n;
    т_время day;
    т_время time;

    try
    {
  dp.parse(s);

  //writefln("year = %d, month = %d, day = %d", dp.year, dp.month, dp.day);
  //writefln("%02d:%02d:%02d.%03d", dp.hour, dp.minute, dp.second, dp.ms);
  //writefln("weekday = %d, ampm = %d, tzcorrection = %d", dp.weekday, 1, dp.tzcorrection);

  time = MakeTime(dp.hour, dp.minute, dp.second, dp.ms);
  if (dp.tzcorrection == int.min)
      time -= LocalTZA;
  else
  {
      time += cast(т_время)(dp.tzcorrection / 100) * msPerHour +
        cast(т_время)(dp.tzcorrection % 100) * msPerMinute;
  }
  day = MakeDay(dp.year, dp.month - 1, dp.day);
  n = MakeDate(day,time);
  n = TimeClip(n);
    }
    catch
    {
  n =  d_time_nan;    // erroneous дата string
    }
    return n;
}

static this()
{
    LocalTZA = дайЛокTZA();
    //эхо("LocalTZA = %g, %g\n", LocalTZA, LocalTZA / msPerHour);
}

version (Win32)
{

    private import sys.WinFuncs;
    //import c.time;

    /******
     * Get current UTC time.
     */
    т_время getUTCtime()
    {
  СИСТВРЕМЯ st;
  т_время n;

  ДайСистВремя(&st);    // get time in UTC
  n = SYSTEMTIME2d_time(&st, 0);
  return n;
  //return c.time.time(null) * TicksPerSecond;
    }

    static т_время FILETIME2d_time(ФВРЕМЯ *ft)
    {   СИСТВРЕМЯ st;

  if (!ФВремяВСистВремя(ft, &st))
      return d_time_nan;
  return SYSTEMTIME2d_time(&st, 0);
    }

    static т_время SYSTEMTIME2d_time(СИСТВРЕМЯ *st, т_время t)
    {
  /* More info: http://delphicikk.atw.hu/listaz.php?id=2667&oldal=52
   */
  т_время n;
  т_время day;
  т_время time;

  if (st.год)
  {
      time = MakeTime(st.час, st.минута, st.секунда, st.миллисекунды);
      day = MakeDay(st.год, st.месяц - 1, st.день);
  }
  else
  {   /* wYear being 0 is a flag to indicate relative time:
       * wMonth is the month 1..12
       * wDayOfWeek is weekday 0..6 corresponding to Sunday..Saturday
       * wDay is the nth time, 1..5, that wDayOfWeek occurs
       */

      auto year = YearFromTime(t);
      auto mday = DateFromNthWeekdayOfMonth(year, st.месяц, st.день, st.день_недели);
      day = MakeDay(year, st.месяц - 1, mday);
      time = MakeTime(st.час, st.минута, 0, 0);
  }
  n = MakeDate(day,time);
  n = TimeClip(n);
  return n;
    }

    т_время дайЛокTZA()
    {
  т_время t;
  DWORD r;
  ИНФОЧП tzi;

  /* http://msdn.microsoft.com/library/en-us/sysinfo/base/gettimezoneinformation.asp
   * http://msdn2.microsoft.com/en-us/library/ms725481.aspx
   */
  r = ДайИнфОЧП(&tzi);
  //эхо("bias = %d\n", tzi.Bias);
  //эхо("standardbias = %d\n", tzi.StandardBias);
  //эхо("daylightbias = %d\n", tzi.DaylightBias);
  switch (r)
  {
      case ПИдЧП.Стд:
    t = -(tzi.Разница + tzi.СтандартнаяРазница) * cast(т_время)(60 * TicksPerSecond);
    break;
      case ПИдЧП.Дэйлайт:
    //t = -(tzi.Bias + tzi.DaylightBias) * cast(т_время)(60 * TicksPerSecond);
    //break;
      case ПИдЧП.Неизв:
    t = -(tzi.Разница) * cast(т_время)(60 * TicksPerSecond);
    break;

      default:
    t = 0;
    break;
  }

  return t;
    }

    /*
     * Get daylight savings time adjust for time dt.
     */

    int DaylightSavingTA(т_время dt)
    {
  int t;
  DWORD r;
  ИНФОЧП tzi;
  т_время ts;
  т_время td;

  /* http://msdn.microsoft.com/library/en-us/sysinfo/base/gettimezoneinformation.asp
   */
  r = ДайИнфОЧП(&tzi);
  t = 0;
  switch (r)
  {
      case ПИдЧП.Стд:
      case ПИдЧП.Дэйлайт:
    if (tzi.СтандартнаяДата.месяц == 0 ||
        tzi.ДатаДейлайт.месяц == 0)
        break;

    ts = SYSTEMTIME2d_time(&tzi.СтандартнаяДата, dt);
    td = SYSTEMTIME2d_time(&tzi.ДатаДейлайт, dt);

    if (td <= dt && dt < ts)
    {
        t = -tzi.РазницаДейлайт * (60 * TicksPerSecond);
        //эхо("DST is in effect, %d\n", t);
    }
    else
    {
        //эхо("no DST\n");
    }
    break;

      case ПИдЧП.Неизв:
    // Daylight savings time not used in this time zone
    break;

      default:
    assert(0);
  }
  return t;
    }
}

version (Posix)
{

    private import os.posix;

    т_время getUTCtime()
    {   timeval tv;

  //эхо("getUTCtime()\n");
  if (gettimeofday(&tv, null))
  {   // Some error happened - try time() instead
      return time(null) * TicksPerSecond;
  }

  return tv.tv_sec * cast(т_время)TicksPerSecond +
    (tv.tv_usec / (1000000 / cast(т_время)TicksPerSecond));
    }

    т_время дайЛокTZA()
    {
  __time_t t;

  time(&t);
      version (OSX)
      { tm результат;
  localtime_r(&t, &результат);
  return результат.tm_gmtoff * TicksPerSecond;
      }
      else
      {
  localtime(&t);  // this will set timezone
  return -(timezone * TicksPerSecond);
      }
    }

    /*
     * Get daylight savings time adjust for time dt.
     */

    int DaylightSavingTA(т_время dt)
    {
  tm *tmp;
  os.posix.__time_t t;
  int dst = 0;

  if (dt != d_time_nan)
  {
      т_время seconds = dt / TicksPerSecond;
      t = cast(__time_t) seconds;
      if (t == seconds) // if in range
      {
    tmp = localtime(&t);
    if (tmp.tm_isdst > 0)
        dst = TicksPerHour; // BUG: Assume daylight savings time is plus one hour.
      }
      else // out of range for system time, use our own calculation
      {
    /* BUG: this works for the US, but not other timezones.
     */

    dt -= LocalTZA;

    int year = YearFromTime(dt);

    /* Compute time given year, month 1..12,
     * week in month, weekday, hour
     */
    т_время dstt(int year, int month, int week, int weekday, int hour)
    {
        auto mday = DateFromNthWeekdayOfMonth(year,  month, weekday, week);
        return TimeClip(MakeDate(
      MakeDay(year, month - 1, mday),
      MakeTime(hour, 0, 0, 0)));
    }

    т_время start;
    т_время end;
    if (year < 2007)
    {   // Daylight savings time goes from 2 AM the first Sunday
        // in April through 2 AM the last Sunday in October
        start = dstt(year,  4, 1, 0, 2);
        end   = dstt(year, 10, 5, 0, 2);
    }
    else
    {
        // the second Sunday of March to
        // the first Sunday in November
        start = dstt(year,  3, 2, 0, 2);
        end   = dstt(year, 11, 1, 0, 2);
    }

    if (start <= dt && dt < end)
        dst = TicksPerHour;
    //writefln("start = %s, dt = %s, end = %s, dst = %s", start, dt, end, dst);
      }
  }
  return dst;
    }

}


/+ ====================== DOS File Time =============================== +/

/***
 * Type representing the DOS file дата/time format.
 */
typedef uint DosFileTime;

/************************************
 * Convert from DOS file дата/time to т_время.
 */

т_время toDtime(DosFileTime time)
{
    uint dt = cast(uint)time;

    if (dt == 0)
  return d_time_nan;

    int year = ((dt >> 25) & 0x7F) + 1980;
    int month = ((dt >> 21) & 0x0F) - 1;  // 0..12
    int dayofmonth = ((dt >> 16) & 0x1F); // 0..31
    int hour = (dt >> 11) & 0x1F;   // 0..23
    int minute = (dt >> 5) & 0x3F;    // 0..59
    int second = (dt << 1) & 0x3E;    // 0..58 (in 2 second increments)

    т_время t;

    t = MakeDate(MakeDay(year, month, dayofmonth),
      MakeTime(hour, minute, second, 0));

    assert(YearFromTime(t) == year);
    assert(MonthFromTime(t) == month);
    assert(DateFromTime(t) == dayofmonth);
    assert(HourFromTime(t) == hour);
    assert(MinFromTime(t) == minute);
    assert(SecFromTime(t) == second);

    t -= LocalTZA + DaylightSavingTA(t);

    return t;
}

/****************************************
 * Convert from т_время to DOS file дата/time.
 */

DosFileTime toDosFileTime(т_время t)
{   uint dt;

    if (t == d_time_nan)
  return cast(DosFileTime)0;

    t += LocalTZA + DaylightSavingTA(t);

    uint year = YearFromTime(t);
    uint month = MonthFromTime(t);
    uint dayofmonth = DateFromTime(t);
    uint hour = HourFromTime(t);
    uint minute = MinFromTime(t);
    uint second = SecFromTime(t);

    dt = (year - 1980) << 25;
    dt |= ((month + 1) & 0x0F) << 21;
    dt |= (dayofmonth & 0x1F) << 16;
    dt |= (hour & 0x1F) << 11;
    dt |= (minute & 0x3F) << 5;
    dt |= (second >> 1) & 0x1F;

    return cast(DosFileTime)dt;
}


//////////////////////////////////////////////////////////

/*
 *  Copyright (C) 1999-2004 by Digital Mars, www.digitalmars.com
 *  Written by Walter Bright
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no событие will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 */

private
{
    import std.string;
    import cidrus;
  import std.utf: вЮ16;
  import sys.WinFuncs;
}

//debug=dateparse;

class ОшибкаРазбораДаты : Исключение
{
    this(char[] s)
    {
  super("Нерабочая строка данных: " ~ s);
   }
}

struct РазборДаты
{
alias parse разбор;
alias parseString разборТекста;

    void parse(char[] s, out Дата дата)
    {
  *this = РазборДаты.init;

  //version (Win32)
      buffer = (cast(char *)alloca(s.length))[0 .. s.length];
  //else
      //buffer = new char[s.length];

  debug(dateparse) эхо("РазборДаты.parse('%.*s')\n", s);
  if (!parseString(s))
  {
      goto Lerror;
  }

    /+
  if (year == year.init)
      year = 0;
  else
    +/
  debug(dateparse)
      эхо("year = %d, month = %d, day = %d\n%02d:%02d:%02d.%03d\nweekday = %d, tzcorrection = %d\n",
    year, month, day,
    hours, minutes, seconds, ms,
    weekday, tzcorrection);
  if (
      year == year.init ||
      (month < 1 || month > 12) ||
      (day < 1 || day > 31) ||
      (hours < 0 || hours > 23) ||
      (minutes < 0 || minutes > 59) ||
      (seconds < 0 || seconds > 59) ||
      (tzcorrection != int.min &&
       ((tzcorrection < -2300 || tzcorrection > 2300) ||
        (tzcorrection % 10)))
      )
  {
   Lerror:
      throw new ОшибкаРазбораДаты(s);
  }

  if (ampm)
  {   if (hours > 12)
    goto Lerror;
      if (hours < 12)
      {
    if (ampm == 2)  // if P.M.
        hours += 12;
      }
      else if (ampm == 1) // if 12am
      {
    hours = 0;    // which is midnight
      }
  }

//  if (tzcorrection != tzcorrection.init)
//      tzcorrection /= 100;

  if (year >= 0 && year <= 99)
      year += 1900;

  дата.year = year;
  дата.month = month;
  дата.day = day;
  дата.hour = hours;
  дата.minute = minutes;
  дата.second = seconds;
  дата.ms = ms;
  дата.weekday = weekday;
  дата.tzcorrection = tzcorrection;
    }


private:
    int year = int.min; // our "nan" Дата value
    int month;    // 1..12
    int day;    // 1..31
    int hours;    // 0..23
    int minutes;  // 0..59
    int seconds;  // 0..59
    int ms;   // 0..999
    int weekday;  // 1..7
    int ampm;   // 0: not specified
      // 1: AM
      // 2: PM
    int tzcorrection = int.min; // -1200..1200 correction in hours

    char[] s;
    int si;
    int number;
    char[] buffer;

    enum DP : byte
    {
  err,
  weekday,
  month,
  number,
  end,
  colon,
  minus,
  slash,
  ampm,
  plus,
  tz,
  dst,
  dsttz,
    }

    DP nextToken()
    {   int nest;
  uint c;
  int bi;
  DP результат = DP.err;

  //эхо("РазборДаты::nextToken()\n");
  for (;;)
  {
      assert(si <= s.length);
      if (si == s.length)
      { результат = DP.end;
    goto Lret;
      }
      //эхо("\ts[%d] = '%c'\n", si, s[si]);
      switch (s[si])
      {
    case ':': результат = DP.colon; goto ret_inc;
    case '+': результат = DP.plus;  goto ret_inc;
    case '-': результат = DP.minus; goto ret_inc;
    case '/': результат = DP.slash; goto ret_inc;
    case '.':
        version(DATE_DOT_DELIM)
        {
      результат = DP.slash;
      goto ret_inc;
        }
        else
        {
      si++;
      break;
        }

    ret_inc:
        si++;
        goto Lret;

    case ' ':
    case '\n':
    case '\r':
    case '\t':
    case ',':
        si++;
        break;

    case '(':   // comment
        nest = 1;
        for (;;)
        {
      si++;
      if (si == s.length)
          goto Lret;    // error
      switch (s[si])
      {
          case '(':
        nest++;
        break;

          case ')':
        if (--nest == 0)
            goto Lendofcomment;
        break;

          default:
        break;
      }
        }
    Lendofcomment:
        si++;
        break;

    default:
        number = 0;
        for (;;)
        {
      if (si == s.length)
          // c cannot be undefined here
          break;
      c = s[si];
      if (!(c >= '0' && c <= '9'))
          break;
      результат = DP.number;
      number = number * 10 + (c - '0');
      si++;
        }
        if (результат == DP.number)
      goto Lret;

        bi = 0;
    bufloop:
        while (c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z')
        {
      if (c < 'a')    // if upper case
          c += cast(uint)'a' - cast(uint)'A'; // to lower case
      buffer[bi] = cast(char)c;
      bi++;
      do
      {
          si++;
          if (si == s.length)
        break bufloop;
          c = s[si];
      } while (c == '.'); // ignore embedded '.'s
        }
        результат = classify(buffer[0 .. bi]);
        goto Lret;
      }
  }
    Lret:
  //эхо("-РазборДаты::nextToken()\n");
  return результат;
    }

    DP classify(char[] buf)
    {
  struct DateID
  {
      char[] name;
      DP tok;
      short value;
  }

  static DateID dateidtab[] =
  [
      {   "january",  DP.month, 1},
      {   "february", DP.month, 2},
      {   "march",  DP.month, 3},
      {   "april",  DP.month, 4},
      {   "may",    DP.month, 5},
      {   "june",   DP.month, 6},
      {   "july",   DP.month, 7},
      {   "august", DP.month, 8},
      {   "september",  DP.month, 9},
      {   "october",  DP.month, 10},
      {   "november", DP.month, 11},
      {   "december", DP.month, 12},
      {   "jan",    DP.month, 1},
      {   "feb",    DP.month, 2},
      {   "mar",    DP.month, 3},
      {   "apr",    DP.month, 4},
      {   "jun",    DP.month, 6},
      {   "jul",    DP.month, 7},
      {   "aug",    DP.month, 8},
      {   "sep",    DP.month, 9},
      {   "sept",   DP.month, 9},
      {   "oct",    DP.month, 10},
      {   "nov",    DP.month, 11},
      {   "dec",    DP.month, 12},

      {   "sunday", DP.weekday, 1},
      {   "monday", DP.weekday, 2},
      {   "tuesday",  DP.weekday, 3},
      {   "tues",   DP.weekday, 3},
      {   "wednesday",  DP.weekday, 4},
      {   "wednes", DP.weekday, 4},
      {   "thursday", DP.weekday, 5},
      {   "thur",   DP.weekday, 5},
      {   "thurs",  DP.weekday, 5},
      {   "friday", DP.weekday, 6},
      {   "saturday", DP.weekday, 7},

      {   "sun",    DP.weekday, 1},
      {   "mon",    DP.weekday, 2},
      {   "tue",    DP.weekday, 3},
      {   "wed",    DP.weekday, 4},
      {   "thu",    DP.weekday, 5},
      {   "fri",    DP.weekday, 6},
      {   "sat",    DP.weekday, 7},

      {   "am",   DP.ampm,    1},
      {   "pm",   DP.ampm,    2},

      {   "gmt",    DP.tz,    +000},
      {   "ut",   DP.tz,    +000},
      {   "utc",    DP.tz,    +000},
      {   "wet",    DP.tz,    +000},
      {   "z",    DP.tz,    +000},
      {   "wat",    DP.tz,    +100},
      {   "a",    DP.tz,    +100},
      {   "at",   DP.tz,    +200},
      {   "b",    DP.tz,    +200},
      {   "c",    DP.tz,    +300},
      {   "ast",    DP.tz,    +400},
      {   "d",    DP.tz,    +400},
      {   "est",    DP.tz,    +500},
      {   "e",    DP.tz,    +500},
      {   "cst",    DP.tz,    +600},
      {   "f",    DP.tz,    +600},
      {   "mst",    DP.tz,    +700},
      {   "g",    DP.tz,    +700},
      {   "pst",    DP.tz,    +800},
      {   "h",    DP.tz,    +800},
      {   "yst",    DP.tz,    +900},
      {   "i",    DP.tz,    +900},
      {   "ahst",   DP.tz,    +1000},
      {   "cat",    DP.tz,    +1000},
      {   "hst",    DP.tz,    +1000},
      {   "k",    DP.tz,    +1000},
      {   "nt",   DP.tz,    +1100},
      {   "l",    DP.tz,    +1100},
      {   "idlw",   DP.tz,    +1200},
      {   "m",    DP.tz,    +1200},

      {   "cet",    DP.tz,    -100},
      {   "fwt",    DP.tz,    -100},
      {   "met",    DP.tz,    -100},
      {   "mewt",   DP.tz,    -100},
      {   "swt",    DP.tz,    -100},
      {   "n",    DP.tz,    -100},
      {   "eet",    DP.tz,    -200},
      {   "o",    DP.tz,    -200},
      {   "bt",   DP.tz,    -300},
      {   "p",    DP.tz,    -300},
      {   "zp4",    DP.tz,    -400},
      {   "q",    DP.tz,    -400},
      {   "zp5",    DP.tz,    -500},
      {   "r",    DP.tz,    -500},
      {   "zp6",    DP.tz,    -600},
      {   "s",    DP.tz,    -600},
      {   "wast",   DP.tz,    -700},
      {   "t",    DP.tz,    -700},
      {   "cct",    DP.tz,    -800},
      {   "u",    DP.tz,    -800},
      {   "jst",    DP.tz,    -900},
      {   "v",    DP.tz,    -900},
      {   "east",   DP.tz,    -1000},
      {   "gst",    DP.tz,    -1000},
      {   "w",    DP.tz,    -1000},
      {   "x",    DP.tz,    -1100},
      {   "idle",   DP.tz,    -1200},
      {   "nzst",   DP.tz,    -1200},
      {   "nzt",    DP.tz,    -1200},
      {   "y",    DP.tz,    -1200},

      {   "bst",    DP.dsttz, 000},
      {   "adt",    DP.dsttz, +400},
      {   "edt",    DP.dsttz, +500},
      {   "cdt",    DP.dsttz, +600},
      {   "mdt",    DP.dsttz, +700},
      {   "pdt",    DP.dsttz, +800},
      {   "ydt",    DP.dsttz, +900},
      {   "hdt",    DP.dsttz, +1000},
      {   "mest",   DP.dsttz, -100},
      {   "mesz",   DP.dsttz, -100},
      {   "sst",    DP.dsttz, -100},
      {   "fst",    DP.dsttz, -100},
      {   "wadt",   DP.dsttz, -700},
      {   "eadt",   DP.dsttz, -1000},
      {   "nzdt",   DP.dsttz, -1200},

      {   "dst",    DP.dst,   0},
    
    {   "январь", DP.month, 1},
      {   "февраль",  DP.month, 2},
      {   "март",     DP.month, 3},
      {   "апрель", DP.month, 4},
      {   "май",    DP.month, 5},
      {   "июнь",   DP.month, 6},
      {   "июль",   DP.month, 7},
      {   "август", DP.month, 8},
      {   "сентябрь", DP.month, 9},
      {   "октябрь",  DP.month, 10},
      {   "ноябрь", DP.month, 11},
      {   "декабрь",  DP.month, 12},
      {   "янв",    DP.month, 1},
      {   "фев",    DP.month, 2},
      {   "мар",    DP.month, 3},
      {   "апр",    DP.month, 4},
      {   "июн",    DP.month, 6},
      {   "июл",    DP.month, 7},
      {   "авг",    DP.month, 8},
      {   "сен",    DP.month, 9},
      {   "сент",   DP.month, 9},
      {   "окт",    DP.month, 10},
      {   "нояб",   DP.month, 11},
      {   "дек",    DP.month, 12},

      {   "воскресенье",  DP.weekday,1},
      {   "понедельник",  DP.weekday,2},
      {   "вторник",  DP.weekday, 3},
      {   "среда",  DP.weekday, 4},
      {   "четверг",  DP.weekday, 5},
      {   "пятница",  DP.weekday, 6},
      {   "суббота",  DP.weekday, 7},

      {   "вс",   DP.weekday, 1},
      {   "пн",   DP.weekday, 2},
      {   "вт",   DP.weekday, 3},
      {   "ср",   DP.weekday, 4},
      {   "чт",   DP.weekday, 5},
      {   "пт",   DP.weekday, 6},
      {   "сб",   DP.weekday, 7},
  ];

  //message(DTEXT("РазборДаты::classify('%s')\n"), buf);

  // Do a linear search. Yes, it would be faster with a binary
  // one.
  for (uint i = 0; i < dateidtab.length; i++)
  {
      if (std.string.cmp(dateidtab[i].name, buf) == 0)
      {
    number = dateidtab[i].value;
    return dateidtab[i].tok;
      }
  }
  return DP.err;
    }

    int parseString(char[] s)
    {
  int n1;
  int dp;
  int sisave;
  int результат;

  //message(DTEXT("РазборДаты::parseString('%ls')\n"), s);
  this.s = s;
  si = 0;
  dp = nextToken();
  for (;;)
  {
      //message(DTEXT("\tdp = %d\n"), dp);
      switch (dp)
      {
    case DP.end:
        результат = 1;
    Lret:
        return результат;

    case DP.err:
    case_error:
        //message(DTEXT("\terror\n"));
    default:
        результат = 0;
        goto Lret;

    case DP.minus:
        break;      // ignore spurious '-'

    case DP.weekday:
        weekday = number;
        break;

    case DP.month:    // month day, [year]
        month = number;
        dp = nextToken();
        if (dp == DP.number)
        {
      day = number;
      sisave = si;
      dp = nextToken();
      if (dp == DP.number)
      {
          n1 = number;
          dp = nextToken();
          if (dp == DP.colon)
          {   // back up, not a year
        si = sisave;
          }
          else
          {   year = n1;
        continue;
          }
          break;
      }
        }
        continue;

    case DP.number:
        n1 = number;
        dp = nextToken();
        switch (dp)
        {
      case DP.end:
          year = n1;
          break;

      case DP.minus:
      case DP.slash:  // n1/ ? ? ?
          dp = parseCalendarDate(n1);
          if (dp == DP.err)
        goto case_error;
          break;

           case DP.colon: // hh:mm [:ss] [am | pm]
          dp = parseTimeOfDay(n1);
          if (dp == DP.err)
        goto case_error;
          break;

           case DP.ampm:
          hours = n1;
          minutes = 0;
          seconds = 0;
          ampm = number;
          break;

      case DP.month:
          day = n1;
          month = number;
          dp = nextToken();
          if (dp == DP.number)
          {   // day month year
        year = number;
        dp = nextToken();
          }
          break;

      default:
          year = n1;
          break;
        }
        continue;
      }
      dp = nextToken();
  }
  assert(0);
    }

    int parseCalendarDate(int n1)
    {
  int n2;
  int n3;
  int dp;

  debug(dateparse) эхо("РазборДаты.parseCalendarDate(%d)\n", n1);
  dp = nextToken();
  if (dp == DP.month) // day/month
  {
      day = n1;
      month = number;
      dp = nextToken();
      if (dp == DP.number)
      {   // day/month year
    year = number;
    dp = nextToken();
      }
      else if (dp == DP.minus || dp == DP.slash)
      {   // day/month/year
    dp = nextToken();
    if (dp != DP.number)
        goto case_error;
    year = number;
    dp = nextToken();
      }
      return dp;
  }
  if (dp != DP.number)
      goto case_error;
  n2 = number;
  //message(DTEXT("\tn2 = %d\n"), n2);
  dp = nextToken();
  if (dp == DP.minus || dp == DP.slash)
  {
      dp = nextToken();
      if (dp != DP.number)
    goto case_error;
      n3 = number;
      //message(DTEXT("\tn3 = %d\n"), n3);
      dp = nextToken();

      // case1: year/month/day
      // case2: month/day/year
      int case1, case2;

      case1 = (n1 > 12 ||
         (n2 >= 1 && n2 <= 12) &&
         (n3 >= 1 && n3 <= 31));
      case2 = ((n1 >= 1 && n1 <= 12) &&
         (n2 >= 1 && n2 <= 31) ||
         n3 > 31);
      if (case1 == case2)
    goto case_error;
      if (case1)
      {
    year = n1;
    month = n2;
    day = n3;
      }
      else
      {
    month = n1;
    day = n2;
    year = n3;
      }
  }
  else
  {   // must be month/day
      month = n1;
      day = n2;
  }
  return dp;

    case_error:
  return DP.err;
    }

    int parseTimeOfDay(int n1)
    {
  int dp;
  int sign;

  // 12am is midnight
  // 12pm is noon

  //message(DTEXT("РазборДаты::parseTimeOfDay(%d)\n"), n1);
  hours = n1;
  dp = nextToken();
  if (dp != DP.number)
      goto case_error;
  minutes = number;
  dp = nextToken();
  if (dp == DP.colon)
  {
      dp = nextToken();
      if (dp != DP.number)
    goto case_error;
      seconds = number;
      dp = nextToken();
  }
  else
      seconds = 0;

  if (dp == DP.ampm)
  {
      ampm = number;
      dp = nextToken();
  }
  else if (dp == DP.plus || dp == DP.minus)
  {
  Loffset:
      sign = (dp == DP.minus) ? -1 : 1;
      dp = nextToken();
      if (dp != DP.number)
    goto case_error;
      tzcorrection = -sign * number;
      dp = nextToken();
  }
  else if (dp == DP.tz)
  {
      tzcorrection = number;
      dp = nextToken();
      if (number == 0 && (dp == DP.plus || dp == DP.minus))
    goto Loffset;
      if (dp == DP.dst)
      {   tzcorrection += 100;
    dp = nextToken();
      }
  }
  else if (dp == DP.dsttz)
  {
      tzcorrection = number;
      dp = nextToken();
  }

  return dp;

    case_error:
  return DP.err;
    }

}

unittest
{
    РазборДаты dp;
    Дата d;

    dp.parse("March 10, 1959 12:00 -800", d);
    assert(d.year         == 1959);
    assert(d.month        == 3);
    assert(d.day          == 10);
    assert(d.hour         == 12);
    assert(d.minute       == 0);
    assert(d.second       == 0);
    assert(d.ms           == 0);
    assert(d.weekday      == 0);
    assert(d.tzcorrection == 800);

    dp.parse("Tue Apr 02 02:04:57 GMT-0800 1996", d);
    assert(d.year         == 1996);
    assert(d.month        == 4);
    assert(d.day          == 2);
    assert(d.hour         == 2);
    assert(d.minute       == 4);
    assert(d.second       == 57);
    assert(d.ms           == 0);
    assert(d.weekday      == 3);
    assert(d.tzcorrection == 800);

    dp.parse("March 14, -1980 21:14:50", d);
    assert(d.year         == 1980);
    assert(d.month        == 3);
    assert(d.day          == 14);
    assert(d.hour         == 21);
    assert(d.minute       == 14);
    assert(d.second       == 50);
    assert(d.ms           == 0);
    assert(d.weekday      == 0);
    assert(d.tzcorrection == int.min);

    dp.parse("Tue Apr 02 02:04:57 1996", d);
    assert(d.year         == 1996);
    assert(d.month        == 4);
    assert(d.day          == 2);
    assert(d.hour         == 2);
    assert(d.minute       == 4);
    assert(d.second       == 57);
    assert(d.ms           == 0);
    assert(d.weekday      == 3);
    assert(d.tzcorrection == int.min);

    dp.parse("Tue, 02 Apr 1996 02:04:57 G.M.T.", d);
    assert(d.year         == 1996);
    assert(d.month        == 4);
    assert(d.day          == 2);
    assert(d.hour         == 2);
    assert(d.minute       == 4);
    assert(d.second       == 57);
    assert(d.ms           == 0);
    assert(d.weekday      == 3);
    assert(d.tzcorrection == 0);

    dp.parse("December 31, 3000", d);
    assert(d.year         == 3000);
    assert(d.month        == 12);
    assert(d.day          == 31);
    assert(d.hour         == 0);
    assert(d.minute       == 0);
    assert(d.second       == 0);
    assert(d.ms           == 0);
    assert(d.weekday      == 0);
    assert(d.tzcorrection == int.min);

    dp.parse("Wed, 31 Dec 1969 16:00:00 GMT", d);
    assert(d.year         == 1969);
    assert(d.month        == 12);
    assert(d.day          == 31);
    assert(d.hour         == 16);
    assert(d.minute       == 0);
    assert(d.second       == 0);
    assert(d.ms           == 0);
    assert(d.weekday      == 4);
    assert(d.tzcorrection == 0);

    dp.parse("1/1/1999 12:30 AM", d);
    assert(d.year         == 1999);
    assert(d.month        == 1);
    assert(d.day          == 1);
    assert(d.hour         == 0);
    assert(d.minute       == 30);
    assert(d.second       == 0);
    assert(d.ms           == 0);
    assert(d.weekday      == 0);
    assert(d.tzcorrection == int.min);

    dp.parse("Tue, 20 May 2003 15:38:58 +0530", d);
    assert(d.year         == 2003);
    assert(d.month        == 5);
    assert(d.day          == 20);
    assert(d.hour         == 15);
    assert(d.minute       == 38);
    assert(d.second       == 58);
    assert(d.ms           == 0);
    assert(d.weekday      == 3);
    assert(d.tzcorrection == -530);

    debug(dateparse) эхо("year = %d, month = %d, day = %d\n%02d:%02d:%02d.%03d\nweekday = %d, tzcorrection = %d\n",
  d.year, d.month, d.day,
  d.hour, d.minute, d.second, d.ms,
  d.weekday, d.tzcorrection);
}


