
module gtkD.glib.Date;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.TimeVal;
private import gtkD.glib.Str;




/**
 * Description
 * The GDate data structure represents a day between January 1, Year 1,
 * and sometime a few thousand years in the future (right now it will go
 * to the year 65535 or so, but g_date_set_parse() only parses up to the
 * year 8000 or so - just count on "a few thousand"). GDate is meant to
 * represent everyday dates, not astronomical dates or historical dates
 * or ISO timestamps or the like. It extrapolates the current Gregorian
 * calendar forward and backward in time; there is no attempt to change
 * the calendar to match time periods or locations. GDate does not store
 * time information; it represents a day.
 * The GDate implementation has several nice features; it is only a
 * 64-bit struct, so storing large numbers of dates is very efficient. It
 * can keep both a Julian and day-month-year representation of the date,
 * since some calculations are much easier with one representation or the
 * other. A Julian representation is simply a count of days since some
 * fixed day in the past; for GDate the fixed day is January 1, 1 AD.
 * ("Julian" dates in the GDate API aren't really Julian dates in the
 * technical sense; technically, Julian dates count from the start of the
 * Julian period, Jan 1, 4713 BC).
 * GDate is simple to use. First you need a "blank" date; you can get a
 * dynamically allocated date from g_date_new(), or you can declare an
 * automatic variable or array and initialize it to a sane state by
 * calling g_date_clear(). A cleared date is sane; it's safe to call
 * g_date_set_dmy() and the other mutator functions to initialize the
 * value of a cleared date. However, a cleared date is initially
 * invalid, meaning that it doesn't represent a day
 * that exists. It is undefined to call any of the date calculation
 * routines on an invalid date. If you obtain a date from a user or other
 * unpredictable source, you should check its validity with the
 * g_date_valid() predicate. g_date_valid() is also used to check for
 * errors with g_date_set_parse() and other functions that can
 * fail. Dates can be invalidated by calling g_date_clear() again.
 * It is very important to use the API to access the GDate
 * struct. Often only the day-month-year or only the Julian
 * representation is valid. Sometimes neither is valid. Use the API.
 * GLib doesn't contain any time-manipulation functions; however, there
 * is a GTime typedef and a GTimeVal struct which represents a more
 * precise time (with microseconds). You can request the current time as
 * a GTimeVal with g_get_current_time().
 */
public class Date
{
	
	/** the main Gtk struct */
	protected GDate* gDate;
	
	
	public GDate* getDateStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GDate* gDate);
	
	/**
	 */
	
	/**
	 * Allocates a GDate and initializes it to a sane state. The new date will
	 * be cleared (as if you'd called g_date_clear()) but invalid (it won't
	 * represent an existing day). Free the return value with g_date_free().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Like g_date_new(), but also sets the value of the date. Assuming the
	 * day-month-year triplet you pass in represents an existing day, the
	 * returned date will be valid.
	 * Params:
	 * day = day of the month
	 * month = month of the year
	 * year = year
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GDateDay day, GDateMonth month, GDateYear year);
	
	/**
	 * Like g_date_new(), but also sets the value of the date. Assuming the
	 * Julian day number you pass in is valid (greater than 0, less than an
	 * unreasonably large number), the returned date will be valid.
	 * Params:
	 * julianDay = days since January 1, Year 1
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (uint julianDay);
	
	/**
	 * Initializes one or more GDate structs to a sane but invalid
	 * state. The cleared dates will not represent an existing date, but will
	 * not contain garbage. Useful to init a date declared on the stack.
	 * Validity can be tested with g_date_valid().
	 * Params:
	 * nDates = number of dates to clear
	 */
	public void clear(uint nDates);
	
	/**
	 * Frees a GDate returned from g_date_new().
	 */
	public void free();
	
	/**
	 * Sets the day of the month for a GDate. If the resulting day-month-year
	 * triplet is invalid, the date will be invalid.
	 * Params:
	 * day = day to set
	 */
	public void setDay(GDateDay day);
	
	/**
	 * Sets the month of the year for a GDate. If the resulting
	 * day-month-year triplet is invalid, the date will be invalid.
	 * Params:
	 * month = month to set
	 */
	public void setMonth(GDateMonth month);
	
	/**
	 * Sets the year for a GDate. If the resulting day-month-year triplet is
	 * invalid, the date will be invalid.
	 * Params:
	 * year = year to set
	 */
	public void setYear(GDateYear year);
	
	/**
	 * Sets the value of a GDate from a day, month, and year. The day-month-year
	 * triplet must be valid; if you aren't sure it is, call g_date_valid_dmy() to
	 * check before you set it.
	 * Params:
	 * day = day
	 * month = month
	 * y = year
	 */
	public void setDmy(GDateDay day, GDateMonth month, GDateYear y);
	
	/**
	 * Sets the value of a GDate from a Julian day number.
	 * Params:
	 * julianDate = Julian day number (days since January 1, Year 1)
	 */
	public void setJulian(uint julianDate);
	
	/**
	 * Warning
	 * g_date_set_time is deprecated and should not be used in newly-written code.
	 * Sets the value of a date from a GTime value.
	 * The time to date conversion is done using the user's current timezone.
	 * Deprecated:2.10: Use g_date_set_time_t() instead.
	 * Params:
	 * time =  GTime value to set.
	 */
	public void setTime(GTime time);
	
	/**
	 * Sets the value of a date to the date corresponding to a time
	 * specified as a time_t. The time to date conversion is done using
	 * the user's current timezone.
	 * Since 2.10
	 * Params:
	 * timet =  time_t value to set
	 */
	public void setTimeT(uint timet);
	
	/**
	 * Sets the value of a date from a GTimeVal value. Note that the
	 * tv_usec member is ignored, because GDate can't make use of the
	 * additional precision.
	 * Since 2.10
	 * Params:
	 * timeval =  GTimeVal value to set
	 */
	public void setTimeVal(TimeVal timeval);
	
	/**
	 * Parses a user-inputted string str, and try to figure out what date it
	 * represents, taking the current locale
	 * into account. If the string is successfully parsed, the date will be
	 * valid after the call. Otherwise, it will be invalid. You should check
	 * using g_date_valid() to see whether the parsing succeeded.
	 * This function is not appropriate for file formats and the like; it
	 * isn't very precise, and its exact behavior varies with the
	 * locale. It's intended to be a heuristic routine that guesses what the
	 * user means by a given string (and it does work pretty well in that
	 * capacity).
	 * Params:
	 * str = string to parse
	 */
	public void setParse(string str);
	
	/**
	 * Increments a date some number of days. To move forward by weeks, add
	 * weeks*7 days. The date must be valid.
	 * Params:
	 * nDays = number of days to move the date forward
	 */
	public void addDays(uint nDays);
	
	/**
	 * Moves a date some number of days into the past. To move by weeks, just
	 * move by weeks*7 days. The date must be valid.
	 * Params:
	 * nDays = number of days to move
	 */
	public void subtractDays(uint nDays);
	
	/**
	 * Increments a date by some number of months. If the day of the month is
	 * greater than 28, this routine may change the day of the month (because
	 * the destination month may not have the current day in it). The date
	 * must be valid.
	 * Params:
	 * nMonths = number of months to move forward
	 */
	public void addMonths(uint nMonths);
	
	/**
	 * Moves a date some number of months into the past. If the current day of
	 * the month doesn't exist in the destination month, the day of the month
	 * may change. The date must be valid.
	 * Params:
	 * nMonths = number of months to move
	 */
	public void subtractMonths(uint nMonths);
	
	/**
	 * Increments a date by some number of years. If the date is February 29,
	 * and the destination year is not a leap year, the date will be changed
	 * to February 28. The date must be valid.
	 * Params:
	 * nYears = number of years to move forward
	 */
	public void addYears(uint nYears);
	
	/**
	 * Moves a date some number of years into the past. If the current day
	 * doesn't exist in the destination year (i.e. it's February 29 and you
	 * move to a non-leap-year) then the day is changed to February 29. The date
	 * must be valid.
	 * Params:
	 * nYears = number of years to move
	 */
	public void subtractYears(uint nYears);
	
	/**
	 * Computes the number of days between two dates.
	 * If date2 is prior to date1, the returned value is negative.
	 * Both dates must be valid.
	 * Params:
	 * date2 = the second date
	 * Returns:the number of days between date1 and date2
	 */
	public int daysBetween(Date date2);
	
	/**
	 * qsort()-style comparsion function for dates. Both
	 * dates must be valid.
	 * Params:
	 * rhs = second date to compare
	 * Returns:0 for equal, less than zero if lhs is less than rhs, greater than zero if lhs is greater than rhs
	 */
	public int compare(Date rhs);
	
	/**
	 * If date is prior to min_date, sets date equal to min_date.
	 * If date falls after max_date, sets date equal to max_date.
	 * Otherwise, date is unchanged.
	 * Either of min_date and max_date may be NULL. All non-NULL dates
	 * must be valid.
	 * Params:
	 * minDate = minimum accepted value for date
	 * maxDate = maximum accepted value for date
	 */
	public void clamp(Date minDate, Date maxDate);
	
	/**
	 * Checks if date1 is less than or equal to date2,
	 * and swap the values if this is not the case.
	 * Params:
	 * date2 = the second date
	 */
	public void order(Date date2);
	
	/**
	 * Returns the day of the month. The date must be valid.
	 * Returns:day of the month
	 */
	public GDateDay getDay();
	
	/**
	 * Returns the month of the year. The date must be valid.
	 * Returns:month of the year as a GDateMonth
	 */
	public GDateMonth getMonth();
	
	/**
	 * Returns the year of a GDate. The date must be valid.
	 * Returns:year in which the date falls
	 */
	public GDateYear getYear();
	
	/**
	 * Returns the Julian day or "serial number" of the GDate. The
	 * Julian day is simply the number of days since January 1, Year 1; i.e.,
	 * January 1, Year 1 is Julian day 1; January 2, Year 1 is Julian day 2,
	 * etc. The date must be valid.
	 * Returns:Julian day
	 */
	public uint getJulian();
	
	/**
	 * Returns the day of the week for a GDate. The date must be valid.
	 * Returns:day of the week as a GDateWeekday.
	 */
	public GDateWeekday getWeekday();
	
	/**
	 * Returns the day of the year, where Jan 1 is the first day of the
	 * year. The date must be valid.
	 * Returns:day of the year
	 */
	public uint getDayOfYear();
	
	/**
	 * Returns the number of days in a month, taking leap years into account.
	 * Params:
	 * month = month
	 * year = year
	 * Returns:number of days in month during the year
	 */
	public static ubyte getDaysInMonth(GDateMonth month, GDateYear year);
	
	/**
	 * Returns TRUE if the date is on the first of a month. The date must be valid.
	 * Returns:%TRUE if the date is the first of the month
	 */
	public int isFirstOfMonth();
	
	/**
	 * Returns TRUE if the date is the last day of the month. The date must be valid.
	 * Returns:%TRUE if the date is the last day of the month
	 */
	public int isLastOfMonth();
	
	/**
	 * Returns TRUE if the year is a leap year.[4]
	 * Params:
	 * year = year to check
	 * Returns:%TRUE if the year is a leap year
	 */
	public static int isLeapYear(GDateYear year);
	
	/**
	 * Returns the week of the year, where weeks are understood to start on
	 * Monday. If the date is before the first Monday of the year, return
	 * 0. The date must be valid.
	 * Returns:week of the year
	 */
	public uint getMondayWeekOfYear();
	
	/**
	 * Returns the number of weeks in the year, where weeks are taken to start
	 * on Monday. Will be 52 or 53. The date must be valid. (Years always have 52
	 * 7-day periods, plus 1 or 2 extra days depending on whether it's a leap
	 * year. This function is basically telling you how many Mondays are in
	 * the year, i.e. there are 53 Mondays if one of the extra days happens
	 * to be a Monday.)
	 * Params:
	 * year = a year
	 * Returns:number of Mondays in the year
	 */
	public static ubyte getMondayWeeksInYear(GDateYear year);
	
	/**
	 * Returns the week of the year during which this date falls, if weeks
	 * are understood to being on Sunday. The date must be valid. Can return 0 if
	 * the day is before the first Sunday of the year.
	 * Returns:week number
	 */
	public uint getSundayWeekOfYear();
	
	/**
	 * Returns the number of weeks in the year, where weeks are taken to start
	 * on Sunday. Will be 52 or 53. The date must be valid. (Years always have 52
	 * 7-day periods, plus 1 or 2 extra days depending on whether it's a leap
	 * year. This function is basically telling you how many Sundays are in
	 * the year, i.e. there are 53 Sundays if one of the extra days happens
	 * to be a Sunday.)
	 * Params:
	 * year = year to count weeks in
	 * Returns:number of weeks
	 */
	public static ubyte getSundayWeeksInYear(GDateYear year);
	
	/**
	 * Returns the week of the year, where weeks are interpreted according
	 * to ISO 8601.
	 * Since 2.6
	 * Returns: ISO 8601 week number of the year.
	 */
	public uint getIso8601_WeekOfYear();
	
	/**
	 * Generates a printed representation of the date, in a
	 * locale-specific way. Works just like
	 * the platform's C library strftime() function, but only accepts date-related
	 * formats; time-related formats give undefined results. Date must be valid.
	 * Unlike strftime() (which uses the locale encoding), works on a UTF-8 format
	 * string and stores a UTF-8 result.
	 * This function does not provide any conversion specifiers in addition
	 * to those implemented by the platform's C library. For example, don't
	 * expect that using g_date_strftime() would make the F provided by the C99
	 * strftime() work on Windows where the C library only complies to C89.
	 * Params:
	 * s = destination buffer
	 * slen = buffer size
	 * format = format string
	 * date = valid GDate
	 * Returns:number of characters written to the buffer, or 0 the buffer was too small
	 */
	public static uint strftime(string s, uint slen, string format, Date date);
	
	/**
	 * Fills in the date-related bits of a struct tm
	 * using the date value. Initializes the non-date parts with something
	 * sane but meaningless.
	 * Params:
	 * tm = struct tm to fill.
	 */
	public void toStructTm(void* tm);
	
	/**
	 * Returns TRUE if the GDate represents an existing day. The date must not
	 * contain garbage; it should have been initialized with g_date_clear()
	 * if it wasn't allocated by one of the g_date_new() variants.
	 * Returns:Whether the date is valid
	 */
	public int valid();
	
	/**
	 * Returns TRUE if the day of the month is valid (a day is valid if it's
	 * between 1 and 31 inclusive).
	 * Params:
	 * day = day to check
	 * Returns:%TRUE if the day is valid
	 */
	public static int validDay(GDateDay day);
	
	/**
	 * Returns TRUE if the month value is valid. The 12 GDateMonth
	 * enumeration values are the only valid months.
	 * Params:
	 * month = month
	 * Returns:%TRUE if the month is valid
	 */
	public static int validMonth(GDateMonth month);
	
	/**
	 * Returns TRUE if the year is valid. Any year greater than 0 is valid,
	 * though there is a 16-bit limit to what GDate will understand.
	 * Params:
	 * year = year
	 * Returns:%TRUE if the year is valid
	 */
	public static int validYear(GDateYear year);
	
	/**
	 * Returns TRUE if the day-month-year triplet forms a valid, existing day
	 * in the range of days GDate understands (Year 1 or later, no more than
	 * a few thousand years in the future).
	 * Params:
	 * day = day
	 * month = month
	 * year = year
	 * Returns:%TRUE if the date is a valid one
	 */
	public static int validDmy(GDateDay day, GDateMonth month, GDateYear year);
	
	/**
	 * Returns TRUE if the Julian day is valid. Anything greater than zero
	 * is basically a valid Julian, though there is a 32-bit limit.
	 * Params:
	 * julianDate = Julian day to check
	 * Returns:%TRUE if the Julian day is valid
	 */
	public static int validJulian(uint julianDate);
	
	/**
	 * Returns TRUE if the weekday is valid. The seven GDateWeekday enumeration
	 * values are the only valid weekdays.
	 * Params:
	 * weekday = weekday
	 * Returns:%TRUE if the weekday is valid[4] For the purposes of this function, leap year is every year divisible by4 unless that year is divisible by 100. If it is divisible by 100 it wouldbe a leap year only if that year is also divisible by 400.
	 */
	public static int validWeekday(GDateWeekday weekday);
}
