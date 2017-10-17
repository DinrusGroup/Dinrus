
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

module std.date;
import  base, sys.WinStructs, std.string;


       struct Дата
      {
      
          цел год;    /// use цел.min as "nan" год значение
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
              год = а.год;    /// use цел.min as "nan" год значение
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


export extern(D)
{

      Дата разборДаты(ткст т)
      {  
      РазборДаты dp;
      Дата д;
      dp.разбор(т, д);
           return  д;
      }




/*
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
*/
      т_время ЛокЧПП = cast(т_время) 0;


      const char[] стрдней = "SunMonTueWedThuFriSatВсПнВтСрЧтПтСб";
      const char[] стрмес = "JanFebMarAprMayJunJulAugSepOctNovDec";

      const цел[12] mdays = [ 0,31,59,90,120,151,181,212,243,273,304,334 ];



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
            return cast(т_время) (МсекВДень * DayFromYear(y));
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
           return dmod(floor(t, cast(т_время) МсекВЧасе),cast(т_время) ЧасовВДне);  
         }

      цел минута(т_время t)  
        {   
            return dmod(floor(t,cast(т_время) МсекВМинуте), cast(т_время)МинутВЧасе);  
             }

      цел секунда(т_время t) 
         {   
             return dmod(floor(t, cast(т_время)ТиковВСекунду), cast(т_время) 60);  
               }

      цел мсек(т_время t) 
        {     
          return dmod(t /cast(т_время) (ТиковВСекунду / 1000),cast(т_время) 1000); 
           }

      цел времениВДне(т_время t) 
       {   
           return dmod(t,cast(т_время) МсекВДень);  
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
          return cast(т_время) разбор(т);
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
      {return cast(т_время) SYSTEMTIME2d_time(св,вр);
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

void toISO8601YearWeek(т_время t, out цел год, out цел week)
{
    год = YearFromTime(t);

    цел yday = Day(t) - DayFromYear(год);
    цел d;
    цел w;
    цел ydaybeg;

    /* Determine день of week Jan 4 falls on.
     * Weeks begin on a Monday.
     */

    d = DayFromYear(год);
    w = (d + 3/*Jan4*/ + 3) % 7;
    if (w < 0)
        w += 7;

    /* Find yday of beginning of ISO 8601 год
     */
    ydaybeg = 3/*Jan4*/ - w;

    /* Check if yday is actually the last week of the previous год
     */
    if (yday < ydaybeg)
    {
  год -= 1;
  week = 53;
        return;
    }

    /* Check if yday is actually the first week of the следщ год
     */
    if (yday >= 362)                            // possible
    {   цел d2;
        цел ydaybeg2;

        d2 = DayFromYear(год + 1);
        w = (d2 + 3/*Jan4*/ + 3) % 7;
        if (w < 0)
            w += 7;
        //эхо("w = %d\n", w);
        ydaybeg2 = 3/*Jan4*/ - w;
        if (d + yday >= d2 + ydaybeg2)
        {
      год += 1;
      week = 1;
            return;
        }
    }

    week = (yday - ydaybeg) / 7 + 1;
}

/* ***********************************
 * Divide время by делитель. Always round down, even if d is negative.
 */


т_время floor(т_время d, цел делитель)
{
    if (d < 0)
  d -= делитель - 1;
    return cast(т_время)(d / делитель);
}

цел dmod(т_время n, т_время d)
{   т_время r;

    r = n % d;
    if (r < 0)
  r += d;
    assert(cast(цел)r == r);
    return cast(цел)r;
}

цел HourFromTime(т_время t)
{
    return dmod(floor(t,cast(т_время) МсекВЧасе), cast(т_время)ЧасовВДне);
}

цел MinFromTime(т_время t)
{
    return dmod(floor(t,cast(т_время) МсекВМинуте),cast(т_время) МинутВЧасе);
}

цел SecFromTime(т_время t)
{
    return dmod(floor(t,cast(т_время) ТиковВСекунду),cast(т_время) 60);
}

цел msFromTime(т_время t)
{
    return dmod(t /cast(т_время) (ТиковВСекунду / 1000), cast(т_время)1000);
}

цел TimeWithinDay(т_время t)
{
    return dmod(t,cast(т_время) МсекВДень);
}


т_время toInteger(т_время n)
{
    return n;
}


цел Day(т_время t)
{
    return cast(цел)floor(t,cast(т_время) МсекВДень);
}

цел LeapYear(цел y)
{
    return ((y & 3) == 0 &&
      (y % 100 || (y % 400) == 0));
}

цел DaysInYear(цел y)
{
    return 365 + LeapYear(y);
}

цел DayFromYear(цел y)
{
    return cast(цел) (365 * (y - 1970) +
    floor(cast(т_время)(y - 1969), 4) -
    floor(cast(т_время)(y - 1901), 100) +
    floor(cast(т_время)(y - 1601), 400));
}

т_время TimeFromYear(цел y)
{
    return cast(т_время)(МсекВДень * DayFromYear(y));
}

/*****************************
 * Calculates the год from the т_время t.
 */

цел YearFromTime(т_время t)
{   цел y;

    if (t == т_время_нч)
  return 0;

    // Hazard a guess
    //y = 1970 + cast(цел) (t / (365.2425 * МсекВДень));
    // Use целeger only math
    y = 1970 + cast(цел) (t / (3652425 * (МсекВДень / 10000)));

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
 * Determines if т_время t is a leap год.
 *
 * A leap год is every 4 years except years ending in 00 that are not
 * divsible by 400.
 *
 * Returns: !=0 if it is a leap год.
 *
 * References:
 *  $(LINK2 http://en.wikipedia.org/wiki/Leap_year, Wikipedia)
 */

цел inLeapYear(т_время t)
{
    return LeapYear(YearFromTime(t));
}

/*****************************
 * Calculates the месяц from the т_время t.
 *
 * Returns: Integer in the range 0..11, where
 *  0 represents January and 11 represents December.
 */

цел MonthFromTime(т_время t)
{
    цел день;
    цел месяц;
    цел год;

    год = YearFromTime(t);
    день = Day(t) - DayFromYear(год);

    if (день < 59)
    {
  if (день < 31)
  {   assert(день >= 0);
      месяц = 0;
  }
  else
      месяц = 1;
    }
    else
    {
  день -= LeapYear(год);
  if (день < 212)
  {
      if (день < 59)
    месяц = 1;
      else if (день < 90)
    месяц = 2;
      else if (день < 120)
    месяц = 3;
      else if (день < 151)
    месяц = 4;
      else if (день < 181)
    месяц = 5;
      else
    месяц = 6;
  }
  else
  {
      if (день < 243)
    месяц = 7;
      else if (день < 273)
    месяц = 8;
      else if (день < 304)
    месяц = 9;
      else if (день < 334)
    месяц = 10;
      else if (день < 365)
    месяц = 11;
      else
    assert(0);
  }
    }
    return месяц;
}

/*******************************
 * Compute which день in a месяц a т_время t is.
 * Returns:
 *  Integer in the range 1..31
 */
цел DateFromTime(т_время t)
{
    цел день;
    цел leap;
    цел месяц;
    цел год;
    цел дата;

    год = YearFromTime(t);
    день = Day(t) - DayFromYear(год);
    leap = LeapYear(год);
    месяц = MonthFromTime(t);
    switch (месяц)
    {
  case 0:  дата = день +   1;    break;
  case 1:  дата = день -  30;    break;
  case 2:  дата = день -  58 - leap; break;
  case 3:  дата = день -  89 - leap; break;
  case 4:  дата = день - 119 - leap; break;
  case 5:  дата = день - 150 - leap; break;
  case 6:  дата = день - 180 - leap; break;
  case 7:  дата = день - 211 - leap; break;
  case 8:  дата = день - 242 - leap; break;
  case 9:  дата = день - 272 - leap; break;
  case 10: дата = день - 303 - leap; break;
  case 11: дата = день - 333 - leap; break;
  default:
      assert(0);
    }
    return дата;
}

/*******************************
 * Compute which день of the week a т_время t is.
 * Returns:
 *  Integer in the range 0..6, where 0 represents Sunday
 *  and 6 represents Saturday.
 */
цел WeekDay(т_время t)
{   цел w;

    w = (cast(цел)Day(t) + 4) % 7;
    if (w < 0)
  w += 7;
    return w;
}

/***********************************
 * Convert from UTC to local время.
 */

т_время UTCtoLocalTime(т_время t)
{
    return (t == т_время_нч)
  ? т_время_нч
  : t + ЛокЧПП + cast(т_время) DaylightSavingTA(t);
}

/***********************************
 * Convert from local время to UTC.
 */

т_время LocalTimetoUTC(т_время t)
{
    return (t == т_время_нч)
  ? т_время_нч
/* BUGZILLA 1752 says this line should be:
 *  : t - ЛокЧПП - DaylightSavingTA(t);
 */
  : t - ЛокЧПП - cast(т_время) DaylightSavingTA(t - ЛокЧПП);
}


т_время MakeTime(т_время час, т_время min, т_время sec, т_время мс)
{
    return час *cast(т_время) ТиковВЧас +
     min * cast(т_время)ТиковВМинуту +
     sec * cast(т_время)ТиковВСекунду +
     мс * cast(т_время)ТиковВМсек;
}

/* *****************************
 * Параметры:
 *  месяц = 0..11
 *  дата = день of месяц, 1..31
 * Returns:
 *  number of days since start of epoch
 */

т_время MakeDay(т_время год, т_время месяц, т_время дата)
{   т_время t;
    цел y;
    цел m;
    цел leap;

    y = cast(цел)(год + floor(месяц, 12));
    m = dmod(месяц, cast(т_время) 12);

    leap = LeapYear(y);
    t = TimeFromYear(y) + cast(т_время)mdays[m] * cast(т_время) МсекВДень;
    if (leap && месяц >= 2)
  t += МсекВДень;

    if (YearFromTime(t) != y ||
  MonthFromTime(t) != m ||
  DateFromTime(t) != 1)
    {
  return  т_время_нч;
    }

    return cast(т_время)(Day(t) + дата - cast(т_время) 1);
}

т_время MakeDate(т_время день, т_время время)
{
    if (день == т_время_нч || время == т_время_нч)
  return т_время_нч;

    return день * cast(т_время) ТиковВДень + время;
}

т_время TimeClip(т_время время)
{
    //эхо("TimeClip(%g) = %g\n", время, toInteger(время));

    return toInteger(время);
}

/***************************************
 * Determine the дата in the месяц, 1..31, of the nth
 * день_недели.
 * Параметры:
 *  год = год
 *  месяц = месяц, 1..12
 *  день_недели = день of week 0..6 representing Sunday..Saturday
 *  n = nth occurrence of that день_недели in the месяц, 1..5, where
 *      5 also means "the last occurrence in the месяц"
 * Returns:
 *  the дата in the месяц, 1..31, of the nth день_недели
 */

цел DateFromNthWeekdayOfMonth(цел год, цел месяц, цел день_недели, цел n)
in
{
    assert(1 <= месяц && месяц <= 12);
    assert(0 <= день_недели && день_недели <= 6);
    assert(1 <= n && n <= 5);
}
body
{
    // Get день of the first of the месяц
    auto x = MakeDay(cast(т_время) год,cast(т_время)( месяц - 1),cast(т_время) 1);

    // Get the week день 0..6 of the first of this месяц
    auto wd = WeekDay(MakeDate(x, cast(т_время) 0));

    // Get monthday of first occurrence of день_недели in this месяц
    auto mday = день_недели - wd + 1;
    if (mday < 1)
  mday += 7;

    // Add in number of weeks
    mday += (n - 1) * 7;

    // If monthday is more than the number of days in the месяц,
    // back up to 'last' occurrence
    if (mday > 28 && mday > DaysInMonth(год, месяц))
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
 * Determine the number of days in a месяц, 1..31.
 * Параметры:
 *  месяц = 1..12
 */

цел DaysInMonth(цел год, цел месяц)
{
    switch (месяц)
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
      return 28 + LeapYear(год);
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
 * Converts UTC время целo a text string of the form:
 * "Www Mmm dd hh:mm:ss GMT+-TZ yyyy".
 * For example, "Tue Apr 02 02:04:57 GMT-0800 1996".
 * If время is invalid, i.e. is т_время_нч,
 * the string "Неверная дата" is returned.
 *
 * Example:
 * ------------------------------------
  т_время lNow;
  char[] lNowString;

  // Grab the дата and время relative to UTC
  lNow = getUTCtime();
  // Convert this целo the local дата and время for display.
  lNowString = toString(lNow);
 * ------------------------------------
 */

string toString(т_время время)
{
    т_время t;
    char sign;
    цел hr;
    цел mn;
    цел len;
    т_время offset;
    т_время dst;

    // Years are supposed to be -285616 .. 285616, or 7 digits
    // "Tue Apr 02 02:04:57 GMT-0800 1996"
    char[] buffer = new char[29 + 7 + 1];

    if (время == т_время_нч)
  return "Неверная дата";

    dst =cast(т_время) DaylightSavingTA(время);
    offset = ЛокЧПП + dst;
    t = время + offset;
    sign = '+';
    if (offset < 0)
    { sign = '-';
//  offset = -offset;
  offset = -(ЛокЧПП + dst);
    }

    mn = cast(цел)(offset / МсекВМинуте);
    hr = mn / 60;
    mn %= 60;

    //эхо("hr = %d, offset = %g, ЛокЧПП = %g, dst = %g, + = %g\n", hr, offset, ЛокЧПП, dst, ЛокЧПП + dst);

    len = sprintf(buffer.ptr, "%.3s %.3s %02d %02d:%02d:%02d GMT%c%02d%02d %d",
  &стрдней[WeekDay(t) * 3],
  &стрмес[MonthFromTime(t) * 3],
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
 * Converts t целo a text string of the form: "Www, dd Mmm yyyy hh:mm:ss UTC".
 * If t is invalid, "Неверная дата" is returned.
 */

string toUTCString(т_время t)
{
    // Years are supposed to be -285616 .. 285616, or 7 digits
    // "Tue, 02 Apr 1996 02:04:57 GMT"
    char[] buffer = new char[25 + 7 + 1];
    цел len;

    if (t == т_время_нч)
  return "Неверная Дата";

    len = sprintf(buffer.ptr, "%.3s, %02d %.3s %d %02d:%02d:%02d UTC",
  &стрдней[WeekDay(t) * 3], DateFromTime(t),
  &стрмес[MonthFromTime(t) * 3],
  YearFromTime(t),
  HourFromTime(t), MinFromTime(t), SecFromTime(t));

    // Ensure no buggy buffer overflows
    assert(len < buffer.length);

    return buffer[0 .. len];
}

/************************************
 * Converts the дата portion of время целo a text string of the form: "Www Mmm dd
 * yyyy", for example, "Tue Apr 02 1996".
 * If время is invalid, "Неверная дата" is returned.
 */

string toDateString(т_время время)
{
    т_время t;
    т_время offset;
    т_время dst;
    цел len;

    // Years are supposed to be -285616 .. 285616, or 7 digits
    // "Tue Apr 02 1996"
    char[] buffer = new char[29 + 7 + 1];

    if (время == т_время_нч)
  return "Неверная Дата";

    dst =cast(т_время) DaylightSavingTA(время);
    offset = ЛокЧПП + dst;
    t = время + offset;

    len = sprintf(buffer.ptr, "%.3s %.3s %02d %d",
  &стрдней[WeekDay(t) * 3],
  &стрмес[MonthFromTime(t) * 3],
  DateFromTime(t),
  cast(long)YearFromTime(t));

    // Ensure no buggy buffer overflows
    assert(len < buffer.length);

    return buffer[0 .. len];
}

/******************************************
 * Converts the время portion of t целo a text string of the form: "hh:mm:ss
 * GMT+-TZ", for example, "02:04:57 GMT-0800".
 * If t is invalid, "Неверная дата" is returned.
 * The input must be in UTC, and the output is in local время.
 */

string toTimeString(т_время время)
{
    т_время t;
    char sign;
    цел hr;
    цел mn;
    цел len;
    т_время offset;
    т_время dst;

    // "02:04:57 GMT-0800"
    char[] buffer = new char[17 + 1];

    if (время == т_время_нч)
  return "Неверная Дата";

    dst = cast(т_время) DaylightSavingTA(время);
    offset = ЛокЧПП + dst;
    t = время + offset;
    sign = '+';
    if (offset < 0)
    { sign = '-';
//  offset = -offset;
  offset = -(ЛокЧПП + dst);
    }

    mn = cast(цел)(offset / МсекВМинуте);
    hr = mn / 60;
    mn %= 60;

    //эхо("hr = %d, offset = %g, ЛокЧПП = %g, dst = %g, + = %g\n", hr, offset, ЛокЧПП, dst, ЛокЧПП + dst);

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
 * If the string is not a valid дата, т_время_нч is returned.
 */

т_время разбор(string s)
{
    Дата dp;
    т_время n;
    т_время день;
    т_время время;

    try
    {
  dp.разбор(s);

  //writefln("год = %d, месяц = %d, день = %d", dp.год, dp.месяц, dp.день);
  //writefln("%02d:%02d:%02d.%03d", dp.час, dp.минута, dp.секунда, dp.мс);
  //writefln("день_недели = %d, ampm = %d, коррекцияЧП = %d", dp.день_недели, 1, dp.коррекцияЧП);

  время = MakeTime(cast(т_время) dp.час,cast(т_время) dp.минута,cast(т_время) dp.секунда,cast(т_время) dp.мс);
  if (dp.коррекцияЧП == цел.min)
      время -= ЛокЧПП;
  else
  {
      время += cast(т_время)(dp.коррекцияЧП / 100) * МсекВЧасе +
        cast(т_время)(dp.коррекцияЧП % 100) * МсекВМинуте;
  }
  день = MakeDay(cast(т_время)dp.год,cast(т_время)( dp.месяц - 1),cast(т_время) dp.день);
  n = MakeDate(день,время);
  n = TimeClip(n);
    }
    catch
    {
  n =  т_время_нч;    // erroneous дата string
    }
    return n;
}

static this()
{
    ЛокЧПП = дайЛокTZA();
    //эхо("ЛокЧПП = %g, %g\n", ЛокЧПП, ЛокЧПП / МсекВЧасе);
}

version (Win32)
{

    private import sys.WinFuncs;
    //import c.время;

    /******
     * Get current UTC время.
     */
    т_время getUTCtime()
    {
  СИСТВРЕМЯ st;
  т_время n;

  ДайСистВремя(&st);    // get время in UTC
  n = SYSTEMTIME2d_time(&st, cast(т_время)0);
  return n;
  //return c.время.время(null) * ТиковВСекунду;
    }

    static т_время FILETIME2d_time(ФВРЕМЯ *ft)
    {   СИСТВРЕМЯ st;

  if (!ФВремяВСистВремя(ft, &st))
      return т_время_нч;
  return SYSTEMTIME2d_time(&st, cast(т_время) 0);
    }

    static т_время SYSTEMTIME2d_time(СИСТВРЕМЯ *st, т_время t)
    {
  /* More info: http://delphicikk.atw.hu/listaz.php?id=2667&oldal=52
   */
  т_время n;
  т_время день;
  т_время время;

  if (st.год)
  {
      время = MakeTime(cast(т_время)st.час, cast(т_время)st.минута,cast(т_время) st.секунда,cast(т_время) st.миллисекунды);
      день = MakeDay(cast(т_время)st.год, cast(т_время)(st.месяц - 1), cast(т_время)st.день);
  }
  else
  {   /* wYear being 0 is a flag to indicate relative время:
       * wMonth is the месяц 1..12
       * wDayOfWeek is день_недели 0..6 corresponding to Sunday..Saturday
       * wDay is the nth время, 1..5, that wDayOfWeek occurs
       */

      auto год = YearFromTime(t);
      auto mday = DateFromNthWeekdayOfMonth(год, st.месяц, st.день, st.день_недели);
      день = MakeDay(cast(т_время)год, cast(т_время)(st.месяц - 1), cast(т_время)mday);
      время = MakeTime(cast(т_время)st.час,cast(т_время) st.минута, cast(т_время)0,cast(т_время) 0);
  }
  n = MakeDate(день,время);
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
    t =cast(т_время)( -(tzi.Разница + tzi.СтандартнаяРазница) * cast(т_время)(60 * ТиковВСекунду));
    break;
      case ПИдЧП.Дэйлайт:
    //t = -(tzi.Bias + tzi.DaylightBias) * cast(т_время)(60 * ТиковВСекунду);
    //break;
      case ПИдЧП.Неизв:
    t = cast(т_время)(-(tzi.Разница) * cast(т_время)(60 * ТиковВСекунду));
    break;

      default:
    t = cast(т_время)0;
    break;
  }

  return t;
    }

    /*
     * Get daylight savings время adjust for время dt.
     */

    цел DaylightSavingTA(т_время dt)
    {
  цел t;
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
        t = -tzi.РазницаДейлайт * (60 * ТиковВСекунду);
        //эхо("DST is in effect, %d\n", t);
    }
    else
    {
        //эхо("no DST\n");
    }
    break;

      case ПИдЧП.Неизв:
    // Daylight savings время not used in this время zone
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
  {   // Some error happened - try время() instead
      return время(null) * ТиковВСекунду;
  }

  return tv.tv_sec * cast(т_время)ТиковВСекунду +
    (tv.tv_usec / (1000000 / cast(т_время)ТиковВСекунду));
    }

    т_время дайЛокTZA()
    {
  __time_t t;

  время(&t);
      version (OSX)
      { tm результат;
  localtime_r(&t, &результат);
  return результат.tm_gmtoff * ТиковВСекунду;
      }
      else
      {
  localtime(&t);  // this will set timezone
  return -(timezone * ТиковВСекунду);
      }
    }

    /*
     * Get daylight savings время adjust for время dt.
     */

    цел DaylightSavingTA(т_время dt)
    {
  tm *tmp;
  os.posix.__time_t t;
  цел dst = 0;

  if (dt != т_время_нч)
  {
      т_время seconds = dt / ТиковВСекунду;
      t = cast(__time_t) seconds;
      if (t == seconds) // if in range
      {
    tmp = localtime(&t);
    if (tmp.tm_isdst > 0)
        dst = ТиковВЧас; // BUG: Assume daylight savings время is plus one час.
      }
      else // out of range for system время, use our own calculation
      {
    /* BUG: this works for the US, but not other timezones.
     */

    dt -= ЛокЧПП;

    цел год = YearFromTime(dt);

    /* Compute время given год, месяц 1..12,
     * week in месяц, день_недели, час
     */
    т_время dstt(цел год, цел месяц, цел week, цел день_недели, цел час)
    {
        auto mday = DateFromNthWeekdayOfMonth(год,  месяц, день_недели, week);
        return TimeClip(MakeDate(
      MakeDay(год, месяц - 1, mday),
      MakeTime(час, 0, 0, 0)));
    }

    т_время start;
    т_время end;
    if (год < 2007)
    {   // Daylight savings время goes from 2 AM the first Sunday
        // in April through 2 AM the last Sunday in October
        start = dstt(год,  4, 1, 0, 2);
        end   = dstt(год, 10, 5, 0, 2);
    }
    else
    {
        // the секунда Sunday of March to
        // the first Sunday in November
        start = dstt(год,  3, 2, 0, 2);
        end   = dstt(год, 11, 1, 0, 2);
    }

    if (start <= dt && dt < end)
        dst = ТиковВЧас;
    //writefln("start = %s, dt = %s, end = %s, dst = %s", start, dt, end, dst);
      }
  }
  return dst;
    }

}


/+ ====================== DOS File Time =============================== +/

/***
 * Type representing the DOS file дата/время format.
 */
typedef бцел DosFileTime;

/************************************
 * Convert from DOS file дата/время to т_время.
 */

т_время toDtime(DosFileTime время)
{
    бцел dt = cast(бцел)время;

    if (dt == 0)
  return т_время_нч;

    цел год = ((dt >> 25) & 0x7F) + 1980;
    цел месяц = ((dt >> 21) & 0x0F) - 1;  // 0..12
    цел dayofmonth = ((dt >> 16) & 0x1F); // 0..31
    цел час = (dt >> 11) & 0x1F;   // 0..23
    цел минута = (dt >> 5) & 0x3F;    // 0..59
    цел секунда = (dt << 1) & 0x3E;    // 0..58 (in 2 секунда increments)

    т_время t;

    t = MakeDate(MakeDay(cast(т_время)год, cast(т_время)месяц, cast(т_время)dayofmonth),
      MakeTime(cast(т_время)час,cast(т_время) минута,cast(т_время) секунда,cast(т_время) 0));

    assert(YearFromTime(t) == год);
    assert(MonthFromTime(t) == месяц);
    assert(DateFromTime(t) == dayofmonth);
    assert(HourFromTime(t) == час);
    assert(MinFromTime(t) == минута);
    assert(SecFromTime(t) == секунда);

    t -= ЛокЧПП + cast(т_время) DaylightSavingTA(t);

    return t;
}

/****************************************
 * Convert from т_время to DOS file дата/время.
 */

DosFileTime toDosFileTime(т_время t)
{   бцел dt;

    if (t == т_время_нч)
  return cast(DosFileTime)0;

    t += ЛокЧПП + DaylightSavingTA(t);

    бцел год = YearFromTime(t);
    бцел месяц = MonthFromTime(t);
    бцел dayofmonth = DateFromTime(t);
    бцел час = HourFromTime(t);
    бцел минута = MinFromTime(t);
    бцел секунда = SecFromTime(t);

    dt = (год - 1980) << 25;
    dt |= ((месяц + 1) & 0x0F) << 21;
    dt |= (dayofmonth & 0x1F) << 16;
    dt |= (час & 0x1F) << 11;
    dt |= (минута & 0x3F) << 5;
    dt |= (секунда >> 1) & 0x1F;

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

//debug=dateразбор;

class ОшибкаРазбораДаты : Исключение
{
    this(char[] s)
    {
  super("Нерабочая строка данных: " ~ s);
   }
}

struct РазборДаты
{

    void разбор(char[] s, out Дата дата)
    {
  *this = РазборДаты.init;

  //version (Win32)
      buffer = (cast(char *)alloca(s.length))[0 .. s.length];
  //else
      //buffer = new char[s.length];

  debug(dateразбор) эхо("РазборДаты.разбор('%.*s')\n", s);
  if (!разборТекста(s))
  {
      goto Lerror;
  }

    /+
  if (год == год.init)
      год = 0;
  else
    +/
  debug(dateразбор)
      эхо("год = %d, месяц = %d, день = %d\n%02d:%02d:%02d.%03d\nweekday = %d, коррекцияЧП = %d\n",
    год, месяц, день,
    hours, minutes, seconds, мс,
    день_недели, коррекцияЧП);
  if (
      год == год.init ||
      (месяц < 1 || месяц > 12) ||
      (день < 1 || день > 31) ||
      (hours < 0 || hours > 23) ||
      (minutes < 0 || minutes > 59) ||
      (seconds < 0 || seconds > 59) ||
      (коррекцияЧП != цел.min &&
       ((коррекцияЧП < -2300 || коррекцияЧП > 2300) ||
        (коррекцияЧП % 10)))
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

//  if (коррекцияЧП != коррекцияЧП.init)
//      коррекцияЧП /= 100;

  if (год >= 0 && год <= 99)
      год += 1900;

  дата.год = год;
  дата.месяц = месяц;
  дата.день = день;
  дата.час = hours;
  дата.минута = minutes;
  дата.секунда = seconds;
  дата.мс = мс;
  дата.день_недели = день_недели;
  дата.коррекцияЧП = коррекцияЧП;
    }


private:
    цел год = цел.min; // our "nan" Дата value
    цел месяц;    // 1..12
    цел день;    // 1..31
    цел hours;    // 0..23
    цел minutes;  // 0..59
    цел seconds;  // 0..59
    цел мс;   // 0..999
    цел день_недели;  // 1..7
    цел ampm;   // 0: not specified
      // 1: AM
      // 2: PM
    цел коррекцияЧП = цел.min; // -1200..1200 correction in hours

    char[] s;
    цел si;
    цел number;
    char[] buffer;

    enum DP : byte
    {
  err,
  день_недели,
  месяц,
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
    {   цел nest;
  бцел c;
  цел bi;
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
          c += cast(бцел)'a' - cast(бцел)'A'; // to lower case
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
      {   "january",  DP.месяц, 1},
      {   "february", DP.месяц, 2},
      {   "march",  DP.месяц, 3},
      {   "april",  DP.месяц, 4},
      {   "may",    DP.месяц, 5},
      {   "june",   DP.месяц, 6},
      {   "july",   DP.месяц, 7},
      {   "august", DP.месяц, 8},
      {   "september",  DP.месяц, 9},
      {   "october",  DP.месяц, 10},
      {   "november", DP.месяц, 11},
      {   "december", DP.месяц, 12},
      {   "jan",    DP.месяц, 1},
      {   "feb",    DP.месяц, 2},
      {   "mar",    DP.месяц, 3},
      {   "apr",    DP.месяц, 4},
      {   "jun",    DP.месяц, 6},
      {   "jul",    DP.месяц, 7},
      {   "aug",    DP.месяц, 8},
      {   "sep",    DP.месяц, 9},
      {   "sept",   DP.месяц, 9},
      {   "oct",    DP.месяц, 10},
      {   "nov",    DP.месяц, 11},
      {   "dec",    DP.месяц, 12},

      {   "sunday", DP.день_недели, 1},
      {   "monday", DP.день_недели, 2},
      {   "tuesday",  DP.день_недели, 3},
      {   "tues",   DP.день_недели, 3},
      {   "wednesday",  DP.день_недели, 4},
      {   "wednes", DP.день_недели, 4},
      {   "thursday", DP.день_недели, 5},
      {   "thur",   DP.день_недели, 5},
      {   "thurs",  DP.день_недели, 5},
      {   "friday", DP.день_недели, 6},
      {   "saturday", DP.день_недели, 7},

      {   "sun",    DP.день_недели, 1},
      {   "mon",    DP.день_недели, 2},
      {   "tue",    DP.день_недели, 3},
      {   "wed",    DP.день_недели, 4},
      {   "thu",    DP.день_недели, 5},
      {   "fri",    DP.день_недели, 6},
      {   "sat",    DP.день_недели, 7},

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
    
    {   "январь", DP.месяц, 1},
      {   "февраль",  DP.месяц, 2},
      {   "март",     DP.месяц, 3},
      {   "апрель", DP.месяц, 4},
      {   "май",    DP.месяц, 5},
      {   "июнь",   DP.месяц, 6},
      {   "июль",   DP.месяц, 7},
      {   "август", DP.месяц, 8},
      {   "сентябрь", DP.месяц, 9},
      {   "октябрь",  DP.месяц, 10},
      {   "ноябрь", DP.месяц, 11},
      {   "декабрь",  DP.месяц, 12},
      {   "янв",    DP.месяц, 1},
      {   "фев",    DP.месяц, 2},
      {   "мар",    DP.месяц, 3},
      {   "апр",    DP.месяц, 4},
      {   "июн",    DP.месяц, 6},
      {   "июл",    DP.месяц, 7},
      {   "авг",    DP.месяц, 8},
      {   "сен",    DP.месяц, 9},
      {   "сент",   DP.месяц, 9},
      {   "окт",    DP.месяц, 10},
      {   "нояб",   DP.месяц, 11},
      {   "дек",    DP.месяц, 12},

      {   "воскресенье",  DP.день_недели,1},
      {   "понедельник",  DP.день_недели,2},
      {   "вторник",  DP.день_недели, 3},
      {   "среда",  DP.день_недели, 4},
      {   "четверг",  DP.день_недели, 5},
      {   "пятница",  DP.день_недели, 6},
      {   "суббота",  DP.день_недели, 7},

      {   "вс",   DP.день_недели, 1},
      {   "пн",   DP.день_недели, 2},
      {   "вт",   DP.день_недели, 3},
      {   "ср",   DP.день_недели, 4},
      {   "чт",   DP.день_недели, 5},
      {   "пт",   DP.день_недели, 6},
      {   "сб",   DP.день_недели, 7},
  ];

  //message(DTEXT("РазборДаты::classify('%s')\n"), buf);

  // Do a linear search. Yes, it would be faster with a binary
  // one.
  for (бцел i = 0; i < dateidtab.length; i++)
  {
      if (std.string.cmp(dateidtab[i].name, buf) == 0)
      {
    number = dateidtab[i].value;
    return dateidtab[i].tok;
      }
  }
  return DP.err;
    }

    цел разборТекста(char[] s)
    {
  цел n1;
  цел dp;
  цел sisave;
  цел результат;

  //message(DTEXT("РазборДаты::разборТекста('%ls')\n"), s);
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

    case DP.день_недели:
        день_недели = number;
        break;

    case DP.месяц:    // месяц день, [год]
        месяц = number;
        dp = nextToken();
        if (dp == DP.number)
        {
      день = number;
      sisave = si;
      dp = nextToken();
      if (dp == DP.number)
      {
          n1 = number;
          dp = nextToken();
          if (dp == DP.colon)
          {   // back up, not a год
        si = sisave;
          }
          else
          {   год = n1;
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
          год = n1;
          break;

      case DP.minus:
      case DP.slash:  // n1/ ? ? ?
          dp = разборCalendarDate(n1);
          if (dp == DP.err)
        goto case_error;
          break;

           case DP.colon: // hh:mm [:ss] [am | pm]
          dp = разборTimeOfDay(n1);
          if (dp == DP.err)
        goto case_error;
          break;

           case DP.ampm:
          hours = n1;
          minutes = 0;
          seconds = 0;
          ampm = number;
          break;

      case DP.месяц:
          день = n1;
          месяц = number;
          dp = nextToken();
          if (dp == DP.number)
          {   // день месяц год
        год = number;
        dp = nextToken();
          }
          break;

      default:
          год = n1;
          break;
        }
        continue;
      }
      dp = nextToken();
  }
  assert(0);
    }

    цел разборCalendarDate(цел n1)
    {
  цел n2;
  цел n3;
  цел dp;

  debug(dateразбор) эхо("РазборДаты.разборCalendarDate(%d)\n", n1);
  dp = nextToken();
  if (dp == DP.месяц) // день/месяц
  {
      день = n1;
      месяц = number;
      dp = nextToken();
      if (dp == DP.number)
      {   // день/месяц год
    год = number;
    dp = nextToken();
      }
      else if (dp == DP.minus || dp == DP.slash)
      {   // день/месяц/год
    dp = nextToken();
    if (dp != DP.number)
        goto case_error;
    год = number;
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

      // case1: год/месяц/день
      // case2: месяц/день/год
      цел case1, case2;

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
    год = n1;
    месяц = n2;
    день = n3;
      }
      else
      {
    месяц = n1;
    день = n2;
    год = n3;
      }
  }
  else
  {   // must be месяц/день
      месяц = n1;
      день = n2;
  }
  return dp;

    case_error:
  return DP.err;
    }

    цел разборTimeOfDay(цел n1)
    {
  цел dp;
  цел sign;

  // 12am is midnight
  // 12pm is noon

  //message(DTEXT("РазборДаты::разборTimeOfDay(%d)\n"), n1);
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
      коррекцияЧП = -sign * number;
      dp = nextToken();
  }
  else if (dp == DP.tz)
  {
      коррекцияЧП = number;
      dp = nextToken();
      if (number == 0 && (dp == DP.plus || dp == DP.minus))
    goto Loffset;
      if (dp == DP.dst)
      {   коррекцияЧП += 100;
    dp = nextToken();
      }
  }
  else if (dp == DP.dsttz)
  {
      коррекцияЧП = number;
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

    dp.разбор("March 10, 1959 12:00 -800", d);
    assert(d.год         == 1959);
    assert(d.месяц        == 3);
    assert(d.день          == 10);
    assert(d.час         == 12);
    assert(d.минута       == 0);
    assert(d.секунда       == 0);
    assert(d.мс           == 0);
    assert(d.день_недели      == 0);
    assert(d.коррекцияЧП == 800);

    dp.разбор("Tue Apr 02 02:04:57 GMT-0800 1996", d);
    assert(d.год         == 1996);
    assert(d.месяц        == 4);
    assert(d.день          == 2);
    assert(d.час         == 2);
    assert(d.минута       == 4);
    assert(d.секунда       == 57);
    assert(d.мс           == 0);
    assert(d.день_недели      == 3);
    assert(d.коррекцияЧП == 800);

    dp.разбор("March 14, -1980 21:14:50", d);
    assert(d.год         == 1980);
    assert(d.месяц        == 3);
    assert(d.день          == 14);
    assert(d.час         == 21);
    assert(d.минута       == 14);
    assert(d.секунда       == 50);
    assert(d.мс           == 0);
    assert(d.день_недели      == 0);
    assert(d.коррекцияЧП == цел.min);

    dp.разбор("Tue Apr 02 02:04:57 1996", d);
    assert(d.год         == 1996);
    assert(d.месяц        == 4);
    assert(d.день          == 2);
    assert(d.час         == 2);
    assert(d.минута       == 4);
    assert(d.секунда       == 57);
    assert(d.мс           == 0);
    assert(d.день_недели      == 3);
    assert(d.коррекцияЧП == цел.min);

    dp.разбор("Tue, 02 Apr 1996 02:04:57 G.M.T.", d);
    assert(d.год         == 1996);
    assert(d.месяц        == 4);
    assert(d.день          == 2);
    assert(d.час         == 2);
    assert(d.минута       == 4);
    assert(d.секунда       == 57);
    assert(d.мс           == 0);
    assert(d.день_недели      == 3);
    assert(d.коррекцияЧП == 0);

    dp.разбор("December 31, 3000", d);
    assert(d.год         == 3000);
    assert(d.месяц        == 12);
    assert(d.день          == 31);
    assert(d.час         == 0);
    assert(d.минута       == 0);
    assert(d.секунда       == 0);
    assert(d.мс           == 0);
    assert(d.день_недели      == 0);
    assert(d.коррекцияЧП == цел.min);

    dp.разбор("Wed, 31 Dec 1969 16:00:00 GMT", d);
    assert(d.год         == 1969);
    assert(d.месяц        == 12);
    assert(d.день          == 31);
    assert(d.час         == 16);
    assert(d.минута       == 0);
    assert(d.секунда       == 0);
    assert(d.мс           == 0);
    assert(d.день_недели      == 4);
    assert(d.коррекцияЧП == 0);

    dp.разбор("1/1/1999 12:30 AM", d);
    assert(d.год         == 1999);
    assert(d.месяц        == 1);
    assert(d.день          == 1);
    assert(d.час         == 0);
    assert(d.минута       == 30);
    assert(d.секунда       == 0);
    assert(d.мс           == 0);
    assert(d.день_недели      == 0);
    assert(d.коррекцияЧП == цел.min);

    dp.разбор("Tue, 20 May 2003 15:38:58 +0530", d);
    assert(d.год         == 2003);
    assert(d.месяц        == 5);
    assert(d.день          == 20);
    assert(d.час         == 15);
    assert(d.минута       == 38);
    assert(d.секунда       == 58);
    assert(d.мс           == 0);
    assert(d.день_недели      == 3);
    assert(d.коррекцияЧП == -530);

    debug(dateразбор) эхо("год = %d, месяц = %d, день = %d\n%02d:%02d:%02d.%03d\nweekday = %d, коррекцияЧП = %d\n",
  d.год, d.месяц, d.день,
  d.час, d.минута, d.секунда, d.мс,
  d.день_недели, d.коррекцияЧП);
}


