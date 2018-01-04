module gtkD.gtk.Calendar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;




private import gtkD.gtk.Widget;

/**
 * Description
 * GtkCalendar is a widget that displays a calendar, one month at a time.
 * It can be created with gtk_calendar_new().
 * The month and year currently displayed can be altered with
 * gtk_calendar_select_month(). The exact day can be selected from the displayed
 * month using gtk_calendar_select_day().
 * To place a visual marker on a particular day, use gtk_calendar_mark_day()
 * and to remove the marker, gtk_calendar_unmark_day().
 * Alternative, all marks can be cleared with gtk_calendar_clear_marks().
 * The way in which the calendar itself is displayed can be altered using
 * gtk_calendar_set_display_options().
 * The selected date can be retrieved from a GtkCalendar using
 * gtk_calendar_get_date().
 */
public class Calendar : Widget
{
	
	/** the main Gtk struct */
	protected GtkCalendar* gtkCalendar;
	
	
	public GtkCalendar* getCalendarStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCalendar* gtkCalendar);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Calendar)[] onDaySelectedListeners;
	/**
	 * Emitted when the user selects a day.
	 */
	void addOnDaySelected(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDaySelected(GtkCalendar* calendarStruct, Calendar calendar);
	
	void delegate(Calendar)[] onDaySelectedDoubleClickListeners;
	/**
	 */
	void addOnDaySelectedDoubleClick(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackDaySelectedDoubleClick(GtkCalendar* calendarStruct, Calendar calendar);
	
	void delegate(Calendar)[] onMonthChangedListeners;
	/**
	 * Emitted when the user clicks a button to change the selected month on a
	 * calendar.
	 */
	void addOnMonthChanged(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackMonthChanged(GtkCalendar* calendarStruct, Calendar calendar);
	
	void delegate(Calendar)[] onNextMonthListeners;
	/**
	 */
	void addOnNextMonth(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackNextMonth(GtkCalendar* calendarStruct, Calendar calendar);
	
	void delegate(Calendar)[] onNextYearListeners;
	/**
	 */
	void addOnNextYear(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackNextYear(GtkCalendar* calendarStruct, Calendar calendar);
	
	void delegate(Calendar)[] onPrevMonthListeners;
	/**
	 */
	void addOnPrevMonth(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPrevMonth(GtkCalendar* calendarStruct, Calendar calendar);
	
	void delegate(Calendar)[] onPrevYearListeners;
	/**
	 */
	void addOnPrevYear(void delegate(Calendar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPrevYear(GtkCalendar* calendarStruct, Calendar calendar);
	
	
	/**
	 * Creates a new calendar, with the current date being selected.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Shifts the calendar to a different month.
	 * Params:
	 * month =  a month number between 0 and 11.
	 * year =  the year the month is in.
	 * Returns: TRUE, always
	 */
	public int selectMonth(uint month, uint year);
	
	/**
	 * Selects a day from the current month.
	 * Params:
	 * day =  the day number between 1 and 31, or 0 to unselect
	 *  the currently selected day.
	 */
	public void selectDay(uint day);
	
	/**
	 * Places a visual marker on a particular day.
	 * Params:
	 * day =  the day number to mark between 1 and 31.
	 * Returns: TRUE, always
	 */
	public int markDay(uint day);
	
	/**
	 * Removes the visual marker from a particular day.
	 * Params:
	 * day =  the day number to unmark between 1 and 31.
	 * Returns: TRUE, always
	 */
	public int unmarkDay(uint day);
	
	/**
	 * Remove all visual markers.
	 */
	public void clearMarks();
	
	/**
	 * Returns the current display options of calendar.
	 * Since 2.4
	 * Returns: the display options.
	 */
	public GtkCalendarDisplayOptions getDisplayOptions();
	
	/**
	 * Sets display options (whether to display the heading and the month
	 * headings).
	 * Since 2.4
	 * Params:
	 * flags =  the display options to set
	 */
	public void setDisplayOptions(GtkCalendarDisplayOptions flags);
	
	/**
	 * Obtains the selected date from a GtkCalendar.
	 * Params:
	 * year =  location to store the year number, or NULL
	 * month =  location to store the month number (between 0 and 11), or NULL
	 * day =  location to store the day number (between 1 and 31), or NULL
	 */
	public void getDate(out uint year, out uint month, out uint day);
	
	/**
	 * Installs a function which provides Pango markup with detail information
	 * for each day. Examples for such details are holidays or appointments. That
	 * information is shown below each day when "show-details" is set.
	 * A tooltip containing with full detail information is provided, if the entire
	 * text should not fit into the details area, or if "show-details"
	 * is not set.
	 * The size of the details area can be restricted by setting the
	 * "detail-width-chars" and "detail-height-rows"
	 * properties.
	 * Since 2.14
	 * Params:
	 * func =  a function providing details for each day.
	 * data =  data to pass to func invokations.
	 * destroy =  a function for releasing data.
	 */
	public void setDetailFunc(GtkCalendarDetailFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * Queries the width of detail cells, in characters.
	 * See "detail-width-chars".
	 * Since 2.14
	 * Returns: The width of detail cells, in characters.
	 */
	public int getDetailWidthChars();
	
	/**
	 * Updates the width of detail cells.
	 * See "detail-width-chars".
	 * Since 2.14
	 * Params:
	 * chars =  detail width in characters.
	 */
	public void setDetailWidthChars(int chars);
	
	/**
	 * Queries the height of detail cells, in rows.
	 * See "detail-width-chars".
	 * Since 2.14
	 * Returns: The height of detail cells, in rows.
	 */
	public int getDetailHeightRows();
	
	/**
	 * Updates the height of detail cells.
	 * See "detail-height-rows".
	 * Since 2.14
	 * Params:
	 * rows =  detail height in rows.
	 */
	public void setDetailHeightRows(int rows);
	
	/**
	 * Warning
	 * gtk_calendar_display_options has been deprecated since version 2.4 and should not be used in newly-written code. Use gtk_calendar_set_display_options() instead
	 * Sets display options (whether to display the heading and the month headings).
	 * Params:
	 * flags =  the display options to set.
	 */
	public void displayOptions(GtkCalendarDisplayOptions flags);
	
	/**
	 * Warning
	 * gtk_calendar_freeze has been deprecated since version 2.8 and should not be used in newly-written code.
	 * Does nothing. Previously locked the display of the calendar until
	 * it was thawed with gtk_calendar_thaw().
	 */
	public void freeze();
	
	/**
	 * Warning
	 * gtk_calendar_thaw has been deprecated since version 2.8 and should not be used in newly-written code.
	 * Does nothing. Previously defrosted a calendar; all the changes made
	 * since the last gtk_calendar_freeze() were displayed.
	 */
	public void thaw();
}
