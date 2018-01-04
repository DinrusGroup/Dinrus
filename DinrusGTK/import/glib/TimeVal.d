module gtkD.glib.TimeVal;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


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
public class TimeVal
{
	
	/** the main Gtk struct */
	protected GTimeVal* gTimeVal;
	
	
	public GTimeVal* getTimeValStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTimeVal* gTimeVal);
	
	/**
	 */
	
	/**
	 * Equivalent to the UNIX gettimeofday() function, but portable.
	 */
	public void getCurrentTime();
	
	/**
	 * Pauses the current thread for the given number of microseconds. There
	 * are 1 million microseconds per second (represented by the
	 * G_USEC_PER_SEC macro). g_usleep() may have limited precision,
	 * depending on hardware and operating system; don't rely on the exact
	 * length of the sleep.
	 * Params:
	 * microseconds = number of microseconds to pause
	 */
	public static void usleep(uint microseconds);
	
	/**
	 * Adds the given number of microseconds to time_. microseconds can
	 * also be negative to decrease the value of time_.
	 * Params:
	 * microseconds =  number of microseconds to add to time
	 */
	public void add(int microseconds);
	
	/**
	 * Converts a string containing an ISO 8601 encoded date and time
	 * to a GTimeVal and puts it into time_.
	 * Since 2.12
	 * Params:
	 * isoDate =  an ISO 8601 encoded date string
	 * time =  a GTimeVal
	 * Returns: TRUE if the conversion was successful.
	 */
	public static int fromIso8601(string isoDate, GTimeVal* time);
	
	/**
	 * Converts time_ into an ISO 8601 encoded string, relative to the
	 * Coordinated Universal Time (UTC).
	 * Since 2.12
	 * Returns: a newly allocated string containing an ISO 8601 date
	 */
	public string toIso8601();
}
