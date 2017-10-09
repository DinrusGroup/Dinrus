
// Написано на языке программирования Динрус. Разработчик Виталий Кулич.

module std.date;
import std.x.date, win;

export extern(D) struct Дата
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

Дата вДату(Date d, out Дата рез)
{
    //Дата рез;
    рез.год = d.year ;  /// use цел.min as "nan" year значение
    рез.месяц = d.month;        /// 1..12
    рез.день = d.day;       /// 1..31
    рез.час = d.hour;       /// 0..23
    рез.минута = d.minute;      /// 0..59
    рез.секунда = d.second;     /// 0..59
    рез.мс = d.ms;      /// 0..999
    рез.день_недели = d.weekday;    /// 0: not specified, 1..7: Sunday..Saturday
    рез.коррекцияЧП = d.tzcorrection;
    return рез;
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

т_время ЛокЧПП = 0;


const char[] стрдней = "SunMonTueWedThuFriSatВсПнВтСрЧтПтСб";
const char[] стрмес = "JanFebMarAprMayJunJulAugSepOctNovDec";

const int[12] mdays = [ 0,31,59,90,120,151,181,212,243,273,304,334 ];



проц  вГодНедИСО8601(т_время t, out цел год, out цел неделя)
{
 std.x.date.toISO8601YearWeek(t, год, неделя);
}

цел День(т_время t) 
{
    return cast(цел)std.x.date.floor(t, 86400000);
     }

цел високосныйГод(цел y)
    {
        return ((y & 3) == 0 &&
            (y % 100 || (y % 400) == 0));
    }

цел днейВГоду(цел y)
    {  
         return 365 + std.x.date.LeapYear(y);  
           }

цел деньИзГода(цел y) 
  {     
    return std.x.date.DayFromYear(y);  
   }

т_время времяИзГода(цел y)
  {   
      return cast(т_время) (msPerDay * std.x.date.DayFromYear(y));
      }

цел Год(т_время t)  
  {
    return std.x.date.YearFromTime(cast(d_time) t);
}

бул високосный_ли(т_время t)
    {
        if(std.x.date.LeapYear(std.x.date.YearFromTime(cast(d_time) t)) != 0)
        return да;
        else return нет;
    }

цел Месяц(т_время t)
    {
        return std.x.date.MonthFromTime(cast(d_time) t);
       }

цел Дата(т_время t)  
 {
    return std.x.date.DateFromTime(cast(d_time) t); 
       }

т_время нокругли(т_время d, цел делитель) 
  { 
    return cast(т_время) std.x.date.floor(cast(d_time) d, делитель);   
         }

цел дмод(т_время n, т_время d)
  { 
    return std.x.date.dmod(n,d);  
      }

цел Час(т_время t)   
 {   
     return std.x.date.dmod(std.x.date.floor(t, msPerHour), HoursPerDay);  
   }

цел Минута(т_время t)  
  {   
      return std.x.date.dmod(std.x.date.floor(t, msPerMinute), MinutesPerHour);  
       }

цел Секунда(т_время t) 
   {   
       return std.x.date.dmod(std.x.date.floor(t, TicksPerSecond), 60);  
         }

цел мсекИзВрем(т_время t) 
  {     
    return std.x.date.dmod(t / (TicksPerSecond / 1000), 1000); 
     }

цел времениВДне(т_время t) 
 {   
     return std.x.date.dmod(t, msPerDay);  
       }

цел ДеньНедели(т_время вр)
{
    return std.x.date.WeekDay(вр);
}

т_время МВ8Местное(т_время вр)
{
    return cast(т_время) std.x.date.UTCtoLocalTime(вр);
}

т_время местное8МВ(т_время вр)
{
    return cast(т_время) std.x.date.LocalTimetoUTC(вр);
}

т_время сделайВремя(т_время час, т_время мин, т_время сек, т_время мс)
{
    return cast(т_время) std.x.date.MakeTime(час, мин, сек, мс);
}

т_время сделайДень(т_время год, т_время месяц, т_время дата)
{
    return cast(т_время) std.x.date.MakeDay(год, месяц, дата);
}

т_время сделайДату(т_время день, т_время вр)
{
    return cast(т_время) std.x.date.MakeDate(день, вр);
}
//d_time TimeClip(d_time время)
цел датаОтДняНеделиМесяца(цел год, цел месяц, цел день_недели, цел ч)
{
    return  std.x.date.DateFromNthWeekdayOfMonth(год, месяц, день_недели, ч);
}

цел днейВМесяце(цел год, цел месяц)
{
    return std.x.date.DaysInMonth(год, месяц);
}

ткст вТкст(т_время время)
{
    return std.x.date.toString(время);
}

ткст вТкстМВ(т_время время)
{
    return std.x.date.toUTCString(время);
}

ткст вТкстДаты(т_время время)
{
    return std.x.date.toDateString(время);
}

ткст вТкстВремени(т_время время)
{
    return std.x.date.toTimeString(время);
}

т_время разборВремени(ткст т)
{
    return cast(т_время) std.x.date.parse(т);
}

т_время дайВремяМВ()
{
    return cast(т_время) std.x.date.getUTCtime();
}

т_время ФВРЕМЯ8т_время(ФВРЕМЯ *фв)
{
    return cast(т_время) std.x.date.FILETIME2d_time(фв);
}

т_время СИСТВРЕМЯ8т_время(СИСТВРЕМЯ *св, т_время вр)
{return cast(т_время) std.x.date.SYSTEMTIME2d_time(св,cast(дол) вр);
}

т_время дайМестнуюЗЧП()
{
    return cast(т_время) std.x.date.дайЛокTZA();
}

цел дневноеСохранениеЧО(т_время вр)
{
    return std.x.date.DaylightSavingTA(вр);
}

т_время вДвремя(ФВремяДос вр)
{
    return cast(т_время) std.x.date.toDtime(cast(DosFileTime) вр);
}

ФВремяДос вФВремяДос(т_время вр)
{
    return cast(ФВремяДос) std.x.date.toDosFileTime(вр);
}

ткст ДАТА()
{
СИСТВРЕМЯ систВремя;
ДайМестнВремя(&систВремя);
ткст ДАТА = вТкст(систВремя.день)~"."~вТкст(систВремя.месяц)~"."~вТкст(систВремя.год);
return  ДАТА;
}

ткст ВРЕМЯ()
{
СИСТВРЕМЯ систВремя;
ДайМестнВремя(&систВремя);
ткст ВРЕМЯ = вТкст(систВремя.час)~" ч. "~вТкст(систВремя.минута)~" мин.";
return  ВРЕМЯ;
}

