module gtkD.gtk.Style;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gdk.Color;
private import gtkD.gdk.Window;
private import gtkD.gdk.Rectangle;
private import gtkD.gtk.IconSet;
private import gtkD.gdk.Pixbuf;
private import gtkD.gtk.IconSource;
private import gtkD.gtk.Widget;
private import gtkD.gdk.Font;
private import gtkD.gdk.Drawable;
private import gtkD.gobject.Value;
private import gtkD.pango.PgLayout;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class Style : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkStyle* gtkStyle;
	
	
	public GtkStyle* getStyleStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkStyle* gtkStyle);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Style)[] onRealizeListeners;
	/**
	 * Emitted when the style has been initialized for a particular
	 * colormap and depth. Connecting to this signal is probably seldom
	 * useful since most of the time applications and widgets only
	 * deal with styles that have been already realized.
	 * Since 2.4
	 */
	void addOnRealize(void delegate(Style) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackRealize(GtkStyle* styleStruct, Style style);
	
	void delegate(Style)[] onUnrealizeListeners;
	/**
	 * Emitted when the aspects of the style specific to a particular colormap
	 * and depth are being cleaned up. A connection to this signal can be useful
	 * if a widget wants to cache objects like a GdkGC as object data on GtkStyle.
	 * This signal provides a convenient place to free such cached objects.
	 * Since 2.4
	 */
	void addOnUnrealize(void delegate(Style) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackUnrealize(GtkStyle* styleStruct, Style style);
	
	
	/**
	 * Creates a new GtkStyle.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Creates a copy of the passed in GtkStyle object.
	 * Returns: a copy of style
	 */
	public Style copy();
	
	/**
	 * Attaches a style to a window; this process allocates the
	 * colors and creates the GC's for the style - it specializes
	 * it to a particular visual and colormap. The process may
	 * involve the creation of a new style if the style has already
	 * been attached to a window with a different style and colormap.
	 * Since this function may return a new object, you have to use it
	 * in the following way:
	 * style = gtk_style_attach (style, window)
	 * Params:
	 * window =  a GdkWindow.
	 * Returns: Either style, or a newly-created GtkStyle. If the style is newly created, the style parameter will be unref'ed, and the new style will have a reference count belonging to the caller.
	 */
	public Style attach(Window window);
	
	/**
	 * Detaches a style from a window. If the style is not attached
	 * to any windows anymore, it is unrealized. See gtk_style_attach().
	 */
	public void detach();
	
	/**
	 * Warning
	 * gtk_style_ref has been deprecated since version 2.0 and should not be used in newly-written code. use g_object_ref() instead.
	 * Increase the reference count of style.
	 * Returns: style.
	 */
	public Style doref();
	
	/**
	 * Warning
	 * gtk_style_unref has been deprecated since version 2.0 and should not be used in newly-written code. use g_object_unref() instead.
	 * Decrease the reference count of style.
	 */
	public void unref();
	
	/**
	 * Sets the background of window to the background color or pixmap
	 * specified by style for the given state.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 */
	public void setBackground(Window window, GtkStateType stateType);
	
	/**
	 * Params:
	 */
	public void applyDefaultBackground(Window window, int setBg, GtkStateType stateType, Rectangle area, int x, int y, int width, int height);
	
	/**
	 * Looks up color_name in the style's logical color mappings,
	 * filling in color and returning TRUE if found, otherwise
	 * returning FALSE. Do not cache the found mapping, because
	 * it depends on the GtkStyle and might change when a theme
	 * switch occurs.
	 * Since 2.10
	 * Params:
	 * colorName =  the name of the logical color to look up
	 * color =  the GdkColor to fill in
	 * Returns: TRUE if the mapping was found.
	 */
	public int lookupColor(string colorName, Color color);
	
	/**
	 * Looks up stock_id in the icon factories associated with style
	 * and the default icon factory, returning an icon set if found,
	 * otherwise NULL.
	 * Params:
	 * stockId =  an icon name
	 * Returns: icon set of stock_id
	 */
	public IconSet lookupIconSet(string stockId);
	
	/**
	 * Renders the icon specified by source at the given size
	 * according to the given parameters and returns the result in a
	 * pixbuf.
	 * Params:
	 * source =  the GtkIconSource specifying the icon to render
	 * direction =  a text direction
	 * state =  a state
	 * size =  the size to render the icon at. A size of (GtkIconSize)-1
	 *  means render at the size of the source and don't scale.
	 * widget =  the widget
	 * detail =  a style detail
	 * Returns: a newly-created GdkPixbuf containing the rendered icon
	 */
	public Pixbuf renderIcon(IconSource source, GtkTextDirection direction, GtkStateType state, GtkIconSize size, Widget widget, string detail);
	
	/**
	 * Warning
	 * gtk_style_get_font is deprecated and should not be used in newly-written code.
	 * Gets the GdkFont to use for the given style. This is
	 * meant only as a replacement for direct access to style->font
	 * and should not be used in new code. New code should
	 * use style->font_desc instead.
	 * Returns: the GdkFont for the style. This font is owned by the style; if you want to keep around a copy, you must call gdk_font_ref().
	 */
	public Font getFont();
	
	/**
	 * Warning
	 * gtk_style_set_font is deprecated and should not be used in newly-written code.
	 * Sets the GdkFont to use for a given style. This is
	 * meant only as a replacement for direct access to style->font
	 * and should not be used in new code. New code should
	 * use style->font_desc instead.
	 * Params:
	 * font =  a GdkFont, or NULL to use the GdkFont corresponding
	 *  to style->font_desc.
	 */
	public void setFont(Font font);

	/**
	 * Queries the value of a style property corresponding to a
	 * widget class is in the given style.
	 * Since 2.16
	 * Params:
	 * widgetType =  the GType of a descendant of GtkWidget
	 * propertyName =  the name of the style property to get
	 * value =  a GValue where the value of the property being
	 *  queried will be stored
	 */
	public void getStyleProperty(GType widgetType, string propertyName, Value value);
	
	/**
	 * Non-vararg variant of gtk_style_get().
	 * Used primarily by language bindings.
	 * Since 2.16
	 * Params:
	 * widgetType =  the GType of a descendant of GtkWidget
	 * firstPropertyName =  the name of the first style property to get
	 * varArgs =  a va_list of pairs of property names and
	 *  locations to return the property values, starting with the
	 *  location for first_property_name.
	 */
	public void getValist(GType widgetType, string firstPropertyName, void* varArgs);
	
	/**
	 * Warning
	 * gtk_draw_hline has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_hline() instead.
	 * Draws a horizontal line from (x1, y) to (x2, y) in window
	 * using the given style and state.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * x1 =  the starting x coordinate
	 * x2 =  the ending x coordinate
	 * y =  the y coordinate
	 */
	public void drawHline(Window window, GtkStateType stateType, int x1, int x2, int y);
	
	/**
	 * Warning
	 * gtk_draw_vline has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_vline() instead.
	 * Draws a vertical line from (x, y1_) to (x, y2_) in window
	 * using the given style and state.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * y1_ =  the starting y coordinate
	 * y2_ =  the ending y coordinate
	 * x =  the x coordinate
	 */
	public void drawVline(Window window, GtkStateType stateType, int y1_, int y2_, int x);
	
	/**
	 * Warning
	 * gtk_draw_shadow has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_shadow() instead.
	 * Draws a shadow around the given rectangle in window
	 * using the given style and state and shadow type.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * x =  x origin of the rectangle
	 * y =  y origin of the rectangle
	 * width =  width of the rectangle
	 * height =  width of the rectangle
	 */
	public void drawShadow(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_polygon has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_polygon() instead.
	 * Draws a polygon on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * points =  an array of GdkPoints
	 * fill =  TRUE if the polygon should be filled
	 */
	public void drawPolygon(Window window, GtkStateType stateType, GtkShadowType shadowType, GdkPoint[] points, int fill);
	
	/**
	 * Warning
	 * gtk_draw_arrow has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_arrow() instead.
	 * Draws an arrow in the given rectangle on window using the given
	 * parameters. arrow_type determines the direction of the arrow.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * arrowType =  the type of arrow to draw
	 * fill =  TRUE if the arrow tip should be filled
	 * x =  x origin of the rectangle to draw the arrow in
	 * y =  y origin of the rectangle to draw the arrow in
	 * width =  width of the rectangle to draw the arrow in
	 * height =  height of the rectangle to draw the arrow in
	 */
	public void drawArrow(Window window, GtkStateType stateType, GtkShadowType shadowType, GtkArrowType arrowType, int fill, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_diamond has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_diamond() instead.
	 * Draws a diamond in the given rectangle on window using the given
	 * parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * x =  x origin of the rectangle to draw the diamond in
	 * y =  y origin of the rectangle to draw the diamond in
	 * width =  width of the rectangle to draw the diamond in
	 * height =  height of the rectangle to draw the diamond in
	 */
	public void drawDiamond(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_string has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_layout() instead.
	 * Draws a text string on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * x =  x origin
	 * y =  y origin
	 * string =  the string to draw
	 */
	public void drawString(Window window, GtkStateType stateType, int x, int y, string string);
	
	/**
	 * Warning
	 * gtk_draw_box has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_box() instead.
	 * Draws a box on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * x =  x origin of the box
	 * y =  y origin of the box
	 * width =  the width of the box
	 * height =  the height of the box
	 */
	public void drawBox(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_box_gap has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_box_gap() instead.
	 * Draws a box in window using the given style and state and shadow type,
	 * leaving a gap in one side.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * x =  x origin of the rectangle
	 * y =  y origin of the rectangle
	 * width =  width of the rectangle
	 * height =  width of the rectangle
	 * gapSide =  side in which to leave the gap
	 * gapX =  starting position of the gap
	 * gapWidth =  width of the gap
	 */
	public void drawBoxGap(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height, GtkPositionType gapSide, int gapX, int gapWidth);
	
	/**
	 * Warning
	 * gtk_draw_check has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_check() instead.
	 * Draws a check button indicator in the given rectangle on window with
	 * the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * x =  x origin of the rectangle to draw the check in
	 * y =  y origin of the rectangle to draw the check in
	 * width =  the width of the rectangle to draw the check in
	 * height =  the height of the rectangle to draw the check in
	 */
	public void drawCheck(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_extension has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_extension() instead.
	 * Draws an extension, i.e. a notebook tab.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * x =  x origin of the extension
	 * y =  y origin of the extension
	 * width =  width of the extension
	 * height =  width of the extension
	 * gapSide =  the side on to which the extension is attached
	 */
	public void drawExtension(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height, GtkPositionType gapSide);
	
	/**
	 * Warning
	 * gtk_draw_flat_box has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_flat_box() instead.
	 * Draws a flat box on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * x =  x origin of the box
	 * y =  y origin of the box
	 * width =  the width of the box
	 * height =  the height of the box
	 */
	public void drawFlatBox(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_focus has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_focus() instead.
	 * Draws a focus indicator around the given rectangle on window using the
	 * given style.
	 * Params:
	 * window =  a GdkWindow
	 * x =  the x origin of the rectangle around which to draw a focus indicator
	 * y =  the y origin of the rectangle around which to draw a focus indicator
	 * width =  the width of the rectangle around which to draw a focus indicator
	 * height =  the height of the rectangle around which to draw a focus indicator
	 */
	public void drawFocus(Window window, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_handle has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_handle() instead.
	 * Draws a handle as used in GtkHandleBox and GtkPaned.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * x =  x origin of the handle
	 * y =  y origin of the handle
	 * width =  with of the handle
	 * height =  height of the handle
	 * orientation =  the orientation of the handle
	 */
	public void drawHandle(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height, GtkOrientation orientation);
	
	/**
	 * Warning
	 * gtk_draw_option has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_option() instead.
	 * Draws a radio button indicator in the given rectangle on window with
	 * the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * x =  x origin of the rectangle to draw the option in
	 * y =  y origin of the rectangle to draw the option in
	 * width =  the width of the rectangle to draw the option in
	 * height =  the height of the rectangle to draw the option in
	 */
	public void drawOption(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_shadow_gap has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_shadow_gap() instead.
	 * Draws a shadow around the given rectangle in window
	 * using the given style and state and shadow type, leaving a
	 * gap in one side.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * x =  x origin of the rectangle
	 * y =  y origin of the rectangle
	 * width =  width of the rectangle
	 * height =  width of the rectangle
	 * gapSide =  side in which to leave the gap
	 * gapX =  starting position of the gap
	 * gapWidth =  width of the gap
	 */
	public void drawShadowGap(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height, GtkPositionType gapSide, int gapX, int gapWidth);
	
	/**
	 * Warning
	 * gtk_draw_slider is deprecated and should not be used in newly-written code.
	 * Draws a slider in the given rectangle on window using the
	 * given style and orientation.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  a shadow
	 * x =  the x origin of the rectangle in which to draw a slider
	 * y =  the y origin of the rectangle in which to draw a slider
	 * width =  the width of the rectangle in which to draw a slider
	 * height =  the height of the rectangle in which to draw a slider
	 * orientation =  the orientation to be used
	 */
	public void drawSlider(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height, GtkOrientation orientation);
	
	/**
	 * Warning
	 * gtk_draw_tab has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_tab() instead.
	 * Draws an option menu tab (i.e. the up and down pointing arrows)
	 * in the given rectangle on window using the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * x =  x origin of the rectangle to draw the tab in
	 * y =  y origin of the rectangle to draw the tab in
	 * width =  the width of the rectangle to draw the tab in
	 * height =  the height of the rectangle to draw the tab in
	 */
	public void drawTab(Window window, GtkStateType stateType, GtkShadowType shadowType, int x, int y, int width, int height);
	
	/**
	 * Warning
	 * gtk_draw_expander has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_expander() instead.
	 * Draws an expander as used in GtkTreeView.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * x =  the x position to draw the expander at
	 * y =  the y position to draw the expander at
	 * expanderStyle =  the style to draw the expander in
	 */
	public void drawExpander(Window window, GtkStateType stateType, int x, int y, GtkExpanderStyle expanderStyle);
	
	/**
	 * Warning
	 * gtk_draw_layout is deprecated and should not be used in newly-written code.
	 * Draws a layout on window using the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * useText =  whether to use the text or foreground
	 *  graphics context of style
	 * x =  x origin
	 * y =  y origin
	 * layout =  the layout to draw
	 */
	public void drawLayout(Window window, GtkStateType stateType, int useText, int x, int y, PgLayout layout);
	
	/**
	 * Warning
	 * gtk_draw_resize_grip has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_resize_grip() instead.
	 * Draws a resize grip in the given rectangle on window using the given
	 * parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * edge =  the edge in which to draw the resize grip
	 * x =  the x origin of the rectangle in which to draw the resize grip
	 * y =  the y origin of the rectangle in which to draw the resize grip
	 * width =  the width of the rectangle in which to draw the resize grip
	 * height =  the height of the rectangle in which to draw the resize grip
	 */
	public void drawResizeGrip(Window window, GtkStateType stateType, GdkWindowEdge edge, int x, int y, int width, int height);
	
	/**
	 * Draws an arrow in the given rectangle on window using the given
	 * parameters. arrow_type determines the direction of the arrow.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * arrowType =  the type of arrow to draw
	 * fill =  TRUE if the arrow tip should be filled
	 * x =  x origin of the rectangle to draw the arrow in
	 * y =  y origin of the rectangle to draw the arrow in
	 * width =  width of the rectangle to draw the arrow in
	 * height =  height of the rectangle to draw the arrow in
	 */
	public void paintArrow(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, GtkArrowType arrowType, int fill, int x, int y, int width, int height);
	
	/**
	 * Draws a box on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the box
	 * y =  y origin of the box
	 * width =  the width of the box
	 * height =  the height of the box
	 */
	public void paintBox(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a box in window using the given style and state and shadow type,
	 * leaving a gap in one side.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle
	 * y =  y origin of the rectangle
	 * width =  width of the rectangle
	 * height =  width of the rectangle
	 * gapSide =  side in which to leave the gap
	 * gapX =  starting position of the gap
	 * gapWidth =  width of the gap
	 */
	public void paintBoxGap(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height, GtkPositionType gapSide, int gapX, int gapWidth);
	
	/**
	 * Draws a check button indicator in the given rectangle on window with
	 * the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle to draw the check in
	 * y =  y origin of the rectangle to draw the check in
	 * width =  the width of the rectangle to draw the check in
	 * height =  the height of the rectangle to draw the check in
	 */
	public void paintCheck(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a diamond in the given rectangle on window using the given
	 * parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle to draw the diamond in
	 * y =  y origin of the rectangle to draw the diamond in
	 * width =  width of the rectangle to draw the diamond in
	 * height =  height of the rectangle to draw the diamond in
	 */
	public void paintDiamond(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws an extension, i.e. a notebook tab.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the extension
	 * y =  y origin of the extension
	 * width =  width of the extension
	 * height =  width of the extension
	 * gapSide =  the side on to which the extension is attached
	 */
	public void paintExtension(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height, GtkPositionType gapSide);
	
	/**
	 * Draws a flat box on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the box
	 * y =  y origin of the box
	 * width =  the width of the box
	 * height =  the height of the box
	 */
	public void paintFlatBox(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a focus indicator around the given rectangle on window using the
	 * given style.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  the x origin of the rectangle around which to draw a focus indicator
	 * y =  the y origin of the rectangle around which to draw a focus indicator
	 * width =  the width of the rectangle around which to draw a focus indicator
	 * height =  the height of the rectangle around which to draw a focus indicator
	 */
	public void paintFocus(Window window, GtkStateType stateType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a handle as used in GtkHandleBox and GtkPaned.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the handle
	 * y =  y origin of the handle
	 * width =  with of the handle
	 * height =  height of the handle
	 * orientation =  the orientation of the handle
	 */
	public void paintHandle(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height, GtkOrientation orientation);
	
	/**
	 * Draws a horizontal line from (x1, y) to (x2, y) in window
	 * using the given style and state.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * area =  rectangle to which the output is clipped, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x1 =  the starting x coordinate
	 * x2 =  the ending x coordinate
	 * y =  the y coordinate
	 */
	public void paintHline(Window window, GtkStateType stateType, Rectangle area, Widget widget, string detail, int x1, int x2, int y);
	
	/**
	 * Draws a radio button indicator in the given rectangle on window with
	 * the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle to draw the option in
	 * y =  y origin of the rectangle to draw the option in
	 * width =  the width of the rectangle to draw the option in
	 * height =  the height of the rectangle to draw the option in
	 */
	public void paintOption(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a polygon on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * points =  an array of GdkPoints
	 * nPoints =  length of points
	 * fill =  TRUE if the polygon should be filled
	 */
	public void paintPolygon(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, GdkPoint[] points, int nPoints, int fill);
	
	/**
	 * Draws a shadow around the given rectangle in window
	 * using the given style and state and shadow type.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * area =  clip rectangle or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle
	 * y =  y origin of the rectangle
	 * width =  width of the rectangle
	 * height =  width of the rectangle
	 */
	public void paintShadow(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a shadow around the given rectangle in window
	 * using the given style and state and shadow type, leaving a
	 * gap in one side.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle
	 * y =  y origin of the rectangle
	 * width =  width of the rectangle
	 * height =  width of the rectangle
	 * gapSide =  side in which to leave the gap
	 * gapX =  starting position of the gap
	 * gapWidth =  width of the gap
	 */
	public void paintShadowGap(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height, GtkPositionType gapSide, int gapX, int gapWidth);
	
	/**
	 * Draws a slider in the given rectangle on window using the
	 * given style and orientation.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  a shadow
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  the x origin of the rectangle in which to draw a slider
	 * y =  the y origin of the rectangle in which to draw a slider
	 * width =  the width of the rectangle in which to draw a slider
	 * height =  the height of the rectangle in which to draw a slider
	 * orientation =  the orientation to be used
	 */
	public void paintSlider(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height, GtkOrientation orientation);
	
	/**
	 * Warning
	 * gtk_paint_string has been deprecated since version 2.0 and should not be used in newly-written code. Use gtk_paint_layout() instead.
	 * Draws a text string on window with the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin
	 * y =  y origin
	 * string =  the string to draw
	 */
	public void paintString(Window window, GtkStateType stateType, Rectangle area, Widget widget, string detail, int x, int y, string string);
	
	/**
	 * Draws an option menu tab (i.e. the up and down pointing arrows)
	 * in the given rectangle on window using the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * shadowType =  the type of shadow to draw
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin of the rectangle to draw the tab in
	 * y =  y origin of the rectangle to draw the tab in
	 * width =  the width of the rectangle to draw the tab in
	 * height =  the height of the rectangle to draw the tab in
	 */
	public void paintTab(Window window, GtkStateType stateType, GtkShadowType shadowType, Rectangle area, Widget widget, string detail, int x, int y, int width, int height);
	
	/**
	 * Draws a vertical line from (x, y1_) to (x, y2_) in window
	 * using the given style and state.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * area =  rectangle to which the output is clipped, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * y1_ =  the starting y coordinate
	 * y2_ =  the ending y coordinate
	 * x =  the x coordinate
	 */
	public void paintVline(Window window, GtkStateType stateType, Rectangle area, Widget widget, string detail, int y1_, int y2_, int x);
	
	/**
	 * Draws an expander as used in GtkTreeView. x and y specify the
	 * center the expander. The size of the expander is determined by the
	 * "expander-size" style property of widget. (If widget is not
	 * specified or doesn't have an "expander-size" property, an
	 * unspecified default size will be used, since the caller doesn't
	 * have sufficient information to position the expander, this is
	 * likely not useful.) The expander is expander_size pixels tall
	 * in the collapsed position and expander_size pixels wide in the
	 * expanded position.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  the x position to draw the expander at
	 * y =  the y position to draw the expander at
	 * expanderStyle =  the style to draw the expander in; determines
	 *  whether the expander is collapsed, expanded, or in an
	 *  intermediate state.
	 */
	public void paintExpander(Window window, GtkStateType stateType, Rectangle area, Widget widget, string detail, int x, int y, GtkExpanderStyle expanderStyle);
	
	/**
	 * Draws a layout on window using the given parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * useText =  whether to use the text or foreground
	 *  graphics context of style
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * x =  x origin
	 * y =  y origin
	 * layout =  the layout to draw
	 */
	public void paintLayout(Window window, GtkStateType stateType, int useText, Rectangle area, Widget widget, string detail, int x, int y, PgLayout layout);
	
	/**
	 * Draws a resize grip in the given rectangle on window using the given
	 * parameters.
	 * Params:
	 * window =  a GdkWindow
	 * stateType =  a state
	 * area =  clip rectangle, or NULL if the
	 *  output should not be clipped
	 * widget =  the widget (may be NULL)
	 * detail =  a style detail (may be NULL)
	 * edge =  the edge in which to draw the resize grip
	 * x =  the x origin of the rectangle in which to draw the resize grip
	 * y =  the y origin of the rectangle in which to draw the resize grip
	 * width =  the width of the rectangle in which to draw the resize grip
	 * height =  the height of the rectangle in which to draw the resize grip
	 */
	public void paintResizeGrip(Window window, GtkStateType stateType, Rectangle area, Widget widget, string detail, GdkWindowEdge edge, int x, int y, int width, int height);
	
	/**
	 * Draws a text caret on drawable at location. This is not a style function
	 * but merely a convenience function for drawing the standard cursor shape.
	 * Since 2.4
	 * Params:
	 * widget =  a GtkWidget
	 * drawable =  a GdkDrawable
	 * area =  rectangle to which the output is clipped, or NULL if the
	 *  output should not be clipped
	 * location =  location where to draw the cursor (location->width is ignored)
	 * isPrimary =  if the cursor should be the primary cursor color.
	 * direction =  whether the cursor is left-to-right or
	 *  right-to-left. Should never be GTK_TEXT_DIR_NONE
	 * drawArrow =  TRUE to draw a directional arrow on the
	 *  cursor. Should be FALSE unless the cursor is split.
	 */
	public static void drawInsertionCursor(Widget widget, Drawable drawable, Rectangle area, Rectangle location, int isPrimary, GtkTextDirection direction, int drawArrow);
}
