
module gtkD.gdk.Color;

public  import gtkD.gtkc.gdktypes;

private import gtkD.gtkc.gdk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gdk.Colormap;




/**
 * Description
 * These functions are used to modify colormaps.
 * A colormap is an object that contains the mapping
 * between the color values stored in memory and
 * the RGB values that are used to display color
 * values. In general, colormaps only contain
 * significant information for pseudo-color visuals,
 * but even for other visual types, a colormap object
 * is required in some circumstances.
 * There are a couple of special colormaps that can
 * be retrieved. The system colormap (retrieved
 * with gdk_colormap_get_system()) is the default
 * colormap of the system. If you are using GdkRGB,
 * there is another colormap that is important - the
 * colormap in which GdkRGB works, retrieved with
 * gdk_rgb_get_colormap(). However, when using GdkRGB,
 * it is not generally necessary to allocate colors
 * directly.
 * In previous revisions of this interface, a number
 * of functions that take a GdkColormap parameter
 * were replaced with functions whose names began
 * with "gdk_colormap_". This process will probably
 * be extended somewhat in the future -
 * gdk_color_white(), gdk_color_black(), and
 * gdk_color_change() will probably become aliases.
 */
public class Color
{
	
	/** the main Gtk struct */
	protected GdkColor* gdkColor;
	
	
	public GdkColor* getColorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdkColor* gdkColor);
	
	static Color _black;
	static Color _white;
	
	/**
	 * Creates a new Color
	 */
	this();
	
	/** */
	this(ubyte red, ubyte green, ubyte blue);
	
	/**
	 * Creates a new Color with RGB values
	 * Params:
	 *  red =
	 *  green =
	 *  blue =
	 */
	this(guint16 red, guint16 green, guint16 blue);
	
	/** */
	this(uint rgb);
	
	/** */
	this(int rgb);
	
	/** */
	static Color black();
	
	/** */
	static Color white();
	
	/**
	 * Sets the Color with RGB values
	 * Params:
	 *  red =
	 *  green =
	 *  blue =
	 */
	void set(guint16 red, guint16 green, guint16 blue);
	
	/** */
	void set8(ubyte red, ubyte green, ubyte blue);
	
	/** */
	uint getValue();
	
	/** */
	int getValue24();
	
	/** */
	uint getPixelValue();
	
	
	/**
	 */
	
	/**
	 * Makes a copy of a color structure. The result
	 * must be freed using gdk_color_free().
	 * Returns: a copy of color.
	 */
	public Color copy();
	
	/**
	 * Frees a color structure created with
	 * gdk_color_copy().
	 */
	public void free();
	
	/**
	 * Warning
	 * gdk_color_white is deprecated and should not be used in newly-written code.
	 * Returns the white color for a given colormap. The resulting
	 * value has already allocated been allocated.
	 * Params:
	 * colormap =  a GdkColormap.
	 * color =  the location to store the color.
	 * Returns: TRUE if the allocation succeeded.
	 */
	public static int white(Colormap colormap, out GdkColor color);
	
	/**
	 * Warning
	 * gdk_color_black is deprecated and should not be used in newly-written code.
	 * Returns the black color for a given colormap. The resulting
	 * value has already benn allocated.
	 * Params:
	 * colormap =  a GdkColormap.
	 * color =  the location to store the color.
	 * Returns: TRUE if the allocation succeeded.
	 */
	public static int black(Colormap colormap, out GdkColor color);
	
	/**
	 * Parses a textual specification of a color and fill in the
	 * red, green,
	 * and blue fields of a GdkColor
	 * structure. The color is not allocated, you
	 * must call gdk_colormap_alloc_color() yourself. The string can
	 * either one of a large set of standard names. (Taken from the X11
	 * rgb.txt file), or it can be a hex value in the
	 * form '#rgb' '#rrggbb' '#rrrgggbbb' or
	 * '#rrrrggggbbbb' where 'r', 'g' and 'b' are hex digits of the
	 * red, green, and blue components of the color, respectively. (White
	 * in the four forms is '#fff' '#ffffff' '#fffffffff' and
	 * '#ffffffffffff')
	 * Params:
	 * spec =  the string specifying the color.
	 * color =  the GdkColor to fill in
	 * Returns: TRUE if the parsing succeeded.
	 */
	public static int parse(string spec, out GdkColor color);
	
	/**
	 * Warning
	 * gdk_color_alloc is deprecated and should not be used in newly-written code. Use gdk_colormap_alloc_color() instead.
	 * Allocates a single color from a colormap.
	 * Params:
	 * colormap =  a GdkColormap.
	 * color =  The color to allocate. On return, the
	 *  pixel field will be filled in.
	 * Returns: TRUE if the allocation succeeded.
	 */
	public static int alloc(Colormap colormap, out GdkColor color);
	
	/**
	 * Warning
	 * gdk_color_change is deprecated and should not be used in newly-written code.
	 * Changes the value of a color that has already
	 * been allocated. If colormap is not a private
	 * colormap, then the color must have been allocated
	 * using gdk_colormap_alloc_colors() with the
	 * writeable set to TRUE.
	 * Params:
	 * colormap =  a GdkColormap.
	 * color =  a GdkColor, with the color to change
	 * in the pixel field,
	 * and the new value in the remaining fields.
	 * Returns: TRUE if the color was successfully changed.
	 */
	public static int change(Colormap colormap, Color color);
	
	/**
	 * Compares two colors.
	 * Params:
	 * colorb =  another GdkColor.
	 * Returns: TRUE if the two colors compare equal
	 */
	public int equal(Color colorb);
	
	/**
	 * A hash function suitable for using for a hash
	 * table that stores GdkColor's.
	 * Returns: The hash function applied to colora
	 */
	public uint hash();
	
	/**
	 * Returns a textual specification of color in the hexadecimal form
	 * #rrrrggggbbbb, where r,
	 * g and b are hex digits
	 * representing the red, green and blue components respectively.
	 * Since 2.12
	 * Returns: a newly-allocated text string
	 */
	public override string toString();
}
