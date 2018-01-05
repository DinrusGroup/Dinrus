module gtkD.gtk.Scale;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.pango.PgLayout;



private import gtkD.gtk.Range;

/**
 * Description
 * A GtkScale is a slider control used to select a numeric value.
 * To use it, you'll probably want to investigate the methods on
 * its base class, GtkRange, in addition to the methods for GtkScale itself.
 * To set the value of a scale, you would normally use gtk_range_set_value().
 * To detect changes to the value, you would normally use the "value_changed"
 * signal.
 * The GtkScale widget is an abstract class, used only for deriving the
 * subclasses GtkHScale and GtkVScale. To create a scale widget,
 * call gtk_hscale_new_with_range() or gtk_vscale_new_with_range().
 * GtkScale as GtkBuildable
 * GtkScale supports a custom <marks> element, which
 * can contain multiple <mark> elements. The "value" and "position"
 * attributes have the same meaning as gtk_scale_add_mark() parameters of the
 * same name. If the element is not empty, its content is taken as the markup
 * to show at the mark. It can be translated with the usual "translatable and
 * "context" attributes.
 */
public class Scale : Range
{
	
	/** the main Gtk struct */
	protected GtkScale* gtkScale;
	
	
	public GtkScale* getScaleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkScale* gtkScale);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	string delegate(gdouble, Scale)[] onFormatValueListeners;
	/**
	 * Signal which allows you to change how the scale value is displayed.
	 * Connect a signal handler which returns an allocated string representing
	 * value. That string will then be used to display the scale's value.
	 * Here's an example signal handler which displays a value 1.0 as
	 * with "-->1.0<--".
	 * static gchar*
	 * format_value_callback (GtkScale *scale,
	 *  gdouble value)
	 * {
		 *  return g_strdup_printf ("-->%0.*g<--",
		 *  gtk_scale_get_digits (scale), value);
	 *  }
	 */
	void addOnFormatValue(string delegate(gdouble, Scale) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackFormatValue(GtkScale* scaleStruct, gdouble value, Scale scale);
	
	
	/**
	 * Sets the number of decimal places that are displayed in the value.
	 * Also causes the value of the adjustment to be rounded off to this
	 * number of digits, so the retrieved value matches the value the user saw.
	 * Params:
	 * digits =  the number of decimal places to display,
	 *  e.g. use 1 to display 1.0, 2 to display 1.00, etc
	 */
	public void setDigits(int digits);
	
	/**
	 * Specifies whether the current value is displayed as a string next
	 * to the slider.
	 * Params:
	 * drawValue =  TRUE to draw the value
	 */
	public void setDrawValue(int drawValue);
	
	/**
	 * Sets the position in which the current value is displayed.
	 * Params:
	 * pos =  the position in which the current value is displayed
	 */
	public void setValuePos(GtkPositionType pos);
	
	/**
	 * Gets the number of decimal places that are displayed in the value.
	 * Returns: the number of decimal places that are displayed
	 */
	public int getDigits();
	
	/**
	 * Returns whether the current value is displayed as a string
	 * next to the slider.
	 * Returns: whether the current value is displayed as a string
	 */
	public int getDrawValue();
	
	/**
	 * Gets the position in which the current value is displayed.
	 * Returns: the position in which the current value is displayed
	 */
	public GtkPositionType getValuePos();
	
	/**
	 * Gets the PangoLayout used to display the scale.
	 * The returned object is owned by the scale so does
	 * not need to be freed by the caller.
	 * Since 2.4
	 * Returns: the PangoLayout for this scale, or NULL  if the "draw-value" property is FALSE.
	 */
	public PgLayout getLayout();
	
	/**
	 * Obtains the coordinates where the scale will draw the
	 * PangoLayout representing the text in the scale. Remember
	 * when using the PangoLayout function you need to convert to
	 * and from pixels using PANGO_PIXELS() or PANGO_SCALE.
	 * If the "draw-value" property is FALSE, the return
	 * values are undefined.
	 * Since 2.4
	 * Params:
	 * x =  location to store X offset of layout, or NULL
	 * y =  location to store Y offset of layout, or NULL
	 */
	public void getLayoutOffsets(out int x, out int y);
	
	/**
	 * Adds a mark at value.
	 * A mark is indicated visually by drawing a tick mark next to the scale,
	 * and GTK+ makes it easy for the user to position the scale exactly at the
	 * marks value.
	 * If markup is not NULL, text is shown next to the tick mark.
	 * To remove marks from a scale, use gtk_scale_clear_marks().
	 * Since 2.16
	 * Params:
	 * value =  the value at which the mark is placed, must be between
	 *  the lower and upper limits of the scales' adjustment
	 * position =  where to draw the mark. For a horizontal scale, GTK_POS_TOP
	 *  is drawn above the scale, anything else below. For a vertical scale,
	 *  GTK_POS_LEFT is drawn to the left of the scale, anything else to the
	 *  right.
	 * markup =  Text to be shown at the mark, using Pango markup, or NULL
	 */
	public void addMark(double value, GtkPositionType position, string markup);
	
	/**
	 * Removes any marks that have been added with gtk_scale_add_mark().
	 * Since 2.16
	 */
	public void clearMarks();
}
