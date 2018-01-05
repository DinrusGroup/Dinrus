module gtkD.gtk.PrintContext;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.cairo.Context;
private import gtkD.pango.PgContext;
private import gtkD.pango.PgFontMap;
private import gtkD.pango.PgLayout;
private import gtkD.gtk.PageSetup;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkPrintContext encapsulates context information that is required when
 * drawing pages for printing, such as the cairo context and important
 * parameters like page size and resolution. It also lets you easily
 * create PangoLayout and PangoContext objects that match the font metrics
 * of the cairo surface.
 * GtkPrintContext objects gets passed to the ::begin-print, ::end-print,
 * ::request-page-setup and ::draw-page signals on the GtkPrintOperation.
 * Example 47. Using GtkPrintContext in a ::draw-page callback
 * static void
 * draw_page (GtkPrintOperation *operation,
 * 	 GtkPrintContext *context,
 * 	 int page_nr)
 * {
	 *  cairo_t *cr;
	 *  PangoLayout *layout;
	 *  PangoFontDescription *desc;
	 *  cr = gtk_print_context_get_cairo_context (context);
	 *  /+* Draw a red rectangle, as wide as the paper (inside the margins) +/
	 *  cairo_set_source_rgb (cr, 1.0, 0, 0);
	 *  cairo_rectangle (cr, 0, 0, gtk_print_context_get_width (context), 50);
	 *  cairo_fill (cr);
	 *  /+* Draw some lines +/
	 *  cairo_move_to (cr, 20, 10);
	 *  cairo_line_to (cr, 40, 20);
	 *  cairo_arc (cr, 60, 60, 20, 0, M_PI);
	 *  cairo_line_to (cr, 80, 20);
	 *  cairo_set_source_rgb (cr, 0, 0, 0);
	 *  cairo_set_line_width (cr, 5);
	 *  cairo_set_line_cap (cr, CAIRO_LINE_CAP_ROUND);
	 *  cairo_set_line_join (cr, CAIRO_LINE_JOIN_ROUND);
	 *  cairo_stroke (cr);
	 *  /+* Draw some text +/
	 *  layout = gtk_print_context_create_layout (context);
	 *  pango_layout_set_text (layout, "Hello World! Printing is easy", -1);
	 *  desc = pango_font_description_from_string ("sans 28");
	 *  pango_layout_set_font_description (layout, desc);
	 *  pango_font_description_free (desc);
	 *  cairo_move_to (cr, 30, 20);
	 *  pango_cairo_layout_path (cr, layout);
	 *  /+* Font Outline +/
	 *  cairo_set_source_rgb (cr, 0.93, 1.0, 0.47);
	 *  cairo_set_line_width (cr, 0.5);
	 *  cairo_stroke_preserve (cr);
	 *  /+* Font Fill +/
	 *  cairo_set_source_rgb (cr, 0, 0.0, 1.0);
	 *  cairo_fill (cr);
	 *  g_object_unref (layout);
 * }
 * Printing support was added in GTK+ 2.10.
 */
public class PrintContext : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkPrintContext* gtkPrintContext;
	
	
	public GtkPrintContext* getPrintContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPrintContext* gtkPrintContext);
	
	/**
	 */
	
	/**
	 * Obtains the cairo context that is associated with the
	 * GtkPrintContext.
	 * Since 2.10
	 * Returns: the cairo context of context
	 */
	public Context getCairoContext();
	
	/**
	 * Sets a new cairo context on a print context.
	 * This function is intended to be used when implementing
	 * an internal print preview, it is not needed for printing,
	 * since GTK+ itself creates a suitable cairo context in that
	 * case.
	 * Since 2.10
	 * Params:
	 * cr =  the cairo context
	 * dpiX =  the horizontal resolution to use with cr
	 * dpiY =  the vertical resolution to use with cr
	 */
	public void setCairoContext(Context cr, double dpiX, double dpiY);
	
	/**
	 * Obtains the GtkPageSetup that determines the page
	 * dimensions of the GtkPrintContext.
	 * Since 2.10
	 * Returns: the page setup of context
	 */
	public PageSetup getPageSetup();
	
	/**
	 * Obtains the width of the GtkPrintContext, in pixels.
	 * Since 2.10
	 * Returns: the width of context
	 */
	public double getWidth();
	
	/**
	 * Obtains the height of the GtkPrintContext, in pixels.
	 * Since 2.10
	 * Returns: the height of context
	 */
	public double getHeight();
	
	/**
	 * Obtains the horizontal resolution of the GtkPrintContext,
	 * in dots per inch.
	 * Since 2.10
	 * Returns: the horizontal resolution of context
	 */
	public double getDpiX();
	
	/**
	 * Obtains the vertical resolution of the GtkPrintContext,
	 * in dots per inch.
	 * Since 2.10
	 * Returns: the vertical resolution of context
	 */
	public double getDpiY();
	
	/**
	 * Returns a PangoFontMap that is suitable for use
	 * with the GtkPrintContext.
	 * Since 2.10
	 * Returns: the font map of context
	 */
	public PgFontMap getPangoFontmap();
	
	/**
	 * Creates a new PangoContext that can be used with the
	 * GtkPrintContext.
	 * Since 2.10
	 * Returns: a new Pango context for context
	 */
	public PgContext createPangoContext();
	
	/**
	 * Creates a new PangoLayout that is suitable for use
	 * with the GtkPrintContext.
	 * Since 2.10
	 * Returns: a new Pango layout for context
	 */
	public PgLayout createPangoLayout();
}
