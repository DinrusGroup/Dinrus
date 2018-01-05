module gtkD.pango.PgAttribute;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.pango.PgAttributeList;
private import gtkD.pango.PgLanguage;
private import gtkD.pango.PgFontDescription;




/**
 * Description
 * Attributed text is used in a number of places in Pango. It
 * is used as the input to the itemization process and also when
 * creating a PangoLayout. The data types and functions in
 * this section are used to represent and manipulate sets
 * of attributes applied to a portion of text.
 */
public class PgAttribute
{
	
	/** the main Gtk struct */
	protected PangoAttribute* pangoAttribute;
	
	
	public PangoAttribute* getPgAttributeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoAttribute* pangoAttribute);
	
	/**
	 */
	
	/**
	 * Parses marked-up text (see
	 * markup format) to create
	 * a plain-text string and an attribute list.
	 * If accel_marker is nonzero, the given character will mark the
	 * character following it as an accelerator. For example, accel_marker
	 * might be an ampersand or underscore. All characters marked
	 * as an accelerator will receive a PANGO_UNDERLINE_LOW attribute,
	 * and the first character so marked will be returned in accel_char.
	 * Two accel_marker characters following each other produce a single
	 * literal accel_marker character.
	 * If any error happens, none of the output arguments are touched except
	 * for error.
	 * Params:
	 * markupText =  markup to parse (see markup format)
	 * length =  length of markup_text, or -1 if nul-terminated
	 * accelMarker =  character that precedes an accelerator, or 0 for none
	 * attrList =  address of return location for a PangoAttrList, or NULL
	 * text =  address of return location for text with tags stripped, or NULL
	 * accelChar =  address of return location for accelerator char, or NULL
	 * Returns: FALSE if error is set, otherwise TRUE
	 * Throws: GException on failure.
	 */
	public static int parseMarkup(string markupText, int length, gunichar accelMarker, out PgAttributeList attrList, out string text, gunichar* accelChar);
	
	/**
	 * Allocate a new attribute type ID. The attribute type name can be accessed
	 * later by using pango_attr_type_get_name().
	 * Params:
	 * name =  an identifier for the type
	 * Returns: the new type ID.
	 */
	public static PangoAttrType typeRegister(string name);
	
	/**
	 * Fetches the attribute type name passed in when registering the type using
	 * pango_attr_type_register().
	 * The returned value is an interned string (see g_intern_string() for what
	 * that means) that should not be modified or freed.
	 * Since 1.22
	 * Params:
	 * type =  an attribute type ID to fetch the name for
	 * Returns: the type ID name (which may be NULL), or NULL if type isa built-in Pango attribute type or invalid.
	 */
	public static string typeGetName(PangoAttrType type);
	
	/**
	 * Initializes attr's klass to klass,
	 * it's start_index to PANGO_ATTR_INDEX_FROM_TEXT_BEGINNING
	 * and end_index to PANGO_ATTR_INDEX_TO_TEXT_END
	 * such that the attribute applies
	 * to the entire text by default.
	 * Since 1.20
	 * Params:
	 * attr =  a PangoAttribute
	 * klass =  a PangoAttributeClass
	 */
	public void attributeInit(PangoAttrClass* klass);
	
	/**
	 * Make a copy of an attribute.
	 * Params:
	 * attr =  a PangoAttribute
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public PgAttribute attributeCopy();
	
	/**
	 * Compare two attributes for equality. This compares only the
	 * actual value of the two attributes and not the ranges that the
	 * attributes apply to.
	 * Params:
	 * attr2 =  another PangoAttribute
	 * Returns: TRUE if the two attributes have the same value.
	 */
	public int attributeEqual(PgAttribute attr2);
	
	/**
	 * Destroy a PangoAttribute and free all associated memory.
	 * Params:
	 * attr =  a PangoAttribute.
	 */
	public void attributeDestroy();
	
	/**
	 * Create a new language tag attribute.
	 * Params:
	 * language =  language tag
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute languageNew(PgLanguage language);
	
	/**
	 * Create a new font family attribute.
	 * Params:
	 * family =  the family or comma separated list of families
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute familyNew(string family);
	
	/**
	 * Create a new font slant style attribute.
	 * Params:
	 * style =  the slant style
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute styleNew(PangoStyle style);
	
	/**
	 * Create a new font variant attribute (normal or small caps)
	 * Params:
	 * variant =  the variant
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute variantNew(PangoVariant variant);
	
	/**
	 * Create a new font stretch attribute
	 * Params:
	 * stretch =  the stretch
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute stretchNew(PangoStretch stretch);
	
	/**
	 * Create a new font weight attribute.
	 * Params:
	 * weight =  the weight
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute weightNew(PangoWeight weight);
	
	/**
	 * Create a new font-size attribute in fractional points.
	 * Params:
	 * size =  the font size, in PANGO_SCALEths of a point.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute sizeNew(int size);
	
	/**
	 * Create a new font-size attribute in device units.
	 * Since 1.8
	 * Params:
	 * size =  the font size, in PANGO_SCALEths of a device unit.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute sizeNewAbsolute(int size);
	
	/**
	 * Create a new font description attribute. This attribute
	 * allows setting family, style, weight, variant, stretch,
	 * and size simultaneously.
	 * Params:
	 * desc =  the font description
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute fontDescNew(PgFontDescription desc);
	
	/**
	 * Create a new foreground color attribute.
	 * Params:
	 * red =  the red value (ranging from 0 to 65535)
	 * green =  the green value
	 * blue =  the blue value
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute foregroundNew(ushort red, ushort green, ushort blue);
	
	/**
	 * Create a new background color attribute.
	 * Params:
	 * red =  the red value (ranging from 0 to 65535)
	 * green =  the green value
	 * blue =  the blue value
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute backgroundNew(ushort red, ushort green, ushort blue);
	
	/**
	 * Create a new strike-through attribute.
	 * Params:
	 * strikethrough =  TRUE if the text should be struck-through.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute strikethroughNew(int strikethrough);
	
	/**
	 * Create a new strikethrough color attribute. This attribute
	 * modifies the color of strikethrough lines. If not set, strikethrough
	 * lines will use the foreground color.
	 * Since 1.8
	 * Params:
	 * red =  the red value (ranging from 0 to 65535)
	 * green =  the green value
	 * blue =  the blue value
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute strikethroughColorNew(ushort red, ushort green, ushort blue);
	
	/**
	 * Create a new underline-style attribute.
	 * Params:
	 * underline =  the underline style.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute underlineNew(PangoUnderline underline);
	
	/**
	 * Create a new underline color attribute. This attribute
	 * modifies the color of underlines. If not set, underlines
	 * will use the foreground color.
	 * Since 1.8
	 * Params:
	 * red =  the red value (ranging from 0 to 65535)
	 * green =  the green value
	 * blue =  the blue value
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute underlineColorNew(ushort red, ushort green, ushort blue);
	
	/**
	 * Create a new shape attribute. A shape is used to impose a
	 * particular ink and logical rectangle on the result of shaping a
	 * particular glyph. This might be used, for instance, for
	 * embedding a picture or a widget inside a PangoLayout.
	 * Params:
	 * inkRect =  ink rectangle to assign to each character
	 * logicalRect =  logical rectangle to assign to each character
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute shapeNew(PangoRectangle* inkRect, PangoRectangle* logicalRect);
	
	/**
	 * Like pango_attr_shape_new(), but a user data pointer is also
	 * provided; this pointer can be accessed when later
	 * rendering the glyph.
	 * Since 1.8
	 * Params:
	 * inkRect =  ink rectangle to assign to each character
	 * logicalRect =  logical rectangle to assign to each character
	 * data =  user data pointer
	 * copyFunc =  function to copy data when the attribute
	 *  is copied. If NULL, data is simply copied
	 *  as a pointer.
	 * destroyFunc =  function to free data when the attribute
	 *  is freed, or NULL
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute shapeNewWithData(PangoRectangle* inkRect, PangoRectangle* logicalRect, void* data, PangoAttrDataCopyFunc copyFunc, GDestroyNotify destroyFunc);
	
	/**
	 * Create a new font size scale attribute. The base font for the
	 * affected text will have its size multiplied by scale_factor.
	 * Params:
	 * scaleFactor =  factor to scale the font
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute scaleNew(double scaleFactor);
	
	/**
	 * Create a new baseline displacement attribute.
	 * Params:
	 * rise =  the amount that the text should be displaced vertically,
	 *  in Pango units. Positive values displace the text upwards.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute riseNew(int rise);
	
	/**
	 * Create a new letter-spacing attribute.
	 * Since 1.6
	 * Params:
	 * letterSpacing =  amount of extra space to add between graphemes
	 *  of the text, in Pango units.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute letterSpacingNew(int letterSpacing);
	
	/**
	 * Create a new font fallback attribute.
	 * If fallback is disabled, characters will only be used from the
	 * closest matching font on the system. No fallback will be done to
	 * other fonts on the system that might contain the characters in the
	 * text.
	 * Since 1.4
	 * Params:
	 * enableFallback =  TRUE if we should fall back on other fonts
	 *  for characters the active font is missing.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute fallbackNew(int enableFallback);
	
	/**
	 * Create a new gravity attribute.
	 * Since 1.16
	 * Params:
	 * gravity =  the gravity value; should not be PANGO_GRAVITY_AUTO.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute gravityNew(PangoGravity gravity);
	
	/**
	 * Create a new gravity hint attribute.
	 * Since 1.16
	 * Params:
	 * hint =  the gravity hint value.
	 * Returns: the newly allocated PangoAttribute, which should be freed with pango_attribute_destroy().
	 */
	public static PgAttribute gravityHintNew(PangoGravityHint hint);
}
