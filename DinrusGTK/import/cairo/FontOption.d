module gtkD.cairo.FontOption;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The font options specify how fonts should be rendered. Most of the time the
 * font options implied by a surface are just right and do not need any changes,
 * but for pixel-based targets tweaking font options may result in superior
 * output on a particular display.
 */
public class FontOption
{
	
	/** the main Gtk struct */
	protected cairo_font_options_t* cairo_font_options;
	
	
	public cairo_font_options_t* getFontOptionStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_font_options_t* cairo_font_options);
	
	/**
	 */
	
	/**
	 * Allocates a new font options object with all options initialized
	 *  to default values.
	 * Returns: a newly allocated cairo_font_options_t. Free with cairo_font_options_destroy(). This function always returns a valid pointer; if memory cannot be allocated, then a special error object is returned where all operations on the object do nothing. You can check for this with cairo_font_options_status().
	 */
	public static FontOption create();
	
	/**
	 * Allocates a new font options object copying the option values from
	 *  original.
	 * Returns: a newly allocated cairo_font_options_t. Free with cairo_font_options_destroy(). This function always returns a valid pointer; if memory cannot be allocated, then a special error object is returned where all operations on the object do nothing. You can check for this with cairo_font_options_status().
	 */
	public FontOption copy();
	
	/**
	 * Destroys a cairo_font_options_t object created with with
	 * cairo_font_options_create() or cairo_font_options_copy().
	 */
	public void destroy();
	
	/**
	 * Checks whether an error has previously occurred for this
	 * font options object
	 * Returns: CAIRO_STATUS_SUCCESS or CAIRO_STATUS_NO_MEMORY
	 */
	public cairo_status_t status();
	
	/**
	 * Merges non-default options from other into options, replacing
	 * existing values. This operation can be thought of as somewhat
	 * similar to compositing other onto options with the operation
	 * of CAIRO_OPERATION_OVER.
	 * Params:
	 * other =  another cairo_font_options_t
	 */
	public void merge(FontOption other);
	
	/**
	 * Compute a hash for the font options object; this value will
	 * be useful when storing an object containing a cairo_font_options_t
	 * in a hash table.
	 * Returns: the hash value for the font options object. The return value can be cast to a 32-bit type if a 32-bit hash value is needed.
	 */
	public ulong hash();
	
	/**
	 * Compares two font options objects for equality.
	 * Params:
	 * other =  another cairo_font_options_t
	 * Returns: TRUE if all fields of the two font options objects match.Note that this function will return FALSE if either object is inerror.
	 */
	public cairo_bool_t equal(FontOption other);
	
	/**
	 * Sets the antialiasing mode for the font options object. This
	 * specifies the type of antialiasing to do when rendering text.
	 * Params:
	 * antialias =  the new antialiasing mode
	 */
	public void setAntialias(cairo_antialias_t antialias);
	
	/**
	 * Gets the antialiasing mode for the font options object.
	 * Returns: the antialiasing mode
	 */
	public cairo_antialias_t getAntialias();
	
	/**
	 * Sets the subpixel order for the font options object. The subpixel
	 * order specifies the order of color elements within each pixel on
	 * the display device when rendering with an antialiasing mode of
	 * CAIRO_ANTIALIAS_SUBPIXEL. See the documentation for
	 * cairo_subpixel_order_t for full details.
	 * Params:
	 * subpixelOrder =  the new subpixel order
	 */
	public void setSubpixelOrder(cairo_subpixel_order_t subpixelOrder);
	
	/**
	 * Gets the subpixel order for the font options object.
	 * See the documentation for cairo_subpixel_order_t for full details.
	 * Returns: the subpixel order for the font options object
	 */
	public cairo_subpixel_order_t getSubpixelOrder();
	
	/**
	 * Sets the hint style for font outlines for the font options object.
	 * This controls whether to fit font outlines to the pixel grid,
	 * and if so, whether to optimize for fidelity or contrast.
	 * See the documentation for cairo_hint_style_t for full details.
	 * Params:
	 * hintStyle =  the new hint style
	 */
	public void setHintStyle(cairo_hint_style_t hintStyle);
	
	/**
	 * Gets the hint style for font outlines for the font options object.
	 * See the documentation for cairo_hint_style_t for full details.
	 * Returns: the hint style for the font options object
	 */
	public cairo_hint_style_t getHintStyle();
	
	/**
	 * Sets the metrics hinting mode for the font options object. This
	 * controls whether metrics are quantized to integer values in
	 * device units.
	 * See the documentation for cairo_hint_metrics_t for full details.
	 * Params:
	 * hintMetrics =  the new metrics hinting mode
	 */
	public void setHintMetrics(cairo_hint_metrics_t hintMetrics);
	
	/**
	 * Gets the metrics hinting mode for the font options object.
	 * See the documentation for cairo_hint_metrics_t for full details.
	 * Returns: the metrics hinting mode for the font options object
	 */
	public cairo_hint_metrics_t getHintMetrics();
}
