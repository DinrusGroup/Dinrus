module gtkD.pango.PgContext;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;
private import gtkD.pango.PgFont;
private import gtkD.pango.PgFontMap;
private import gtkD.pango.PgFontset;
private import gtkD.pango.PgFontFamily;
private import gtkD.pango.PgFontMetrics;
private import gtkD.pango.PgFontDescription;
private import gtkD.pango.PgLanguage;
private import gtkD.pango.PgMatrix;
private import gtkD.pango.PgAttributeList;
private import gtkD.pango.PgAttributeIterator;
private import gtkD.pango.PgGlyphString;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The Pango rendering pipeline takes a string of
 * Unicode characters and converts it into glyphs.
 * The functions described in this section accomplish
 * various steps of this process.
 */
public class PgContext : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoContext* pangoContext;
	
	
	public PangoContext* getPgContextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoContext* pangoContext);
	
	/**
	 * Determines possible line, word, and character breaks
	 * for a string of Unicode text with a single analysis. For most
	 * purposes you may want to use pango_get_log_attrs().
	 * Params:
	 * text =  the text to process
	 * length =  length of text in bytes (may be -1 if text is nul-terminated)
	 * analysis =  PangoAnalysis structure from pango_itemize()
	 * attrs =  an array to store character information in
	 * attrsLen =  size of the array passed as attrs
	 */
	public static void pangoBreak(string text, int length, PangoAnalysis* analysis, PangoLogAttr* attrs, int attrsLen);
	
	/**
	 * Description
	 * Pango supports bidirectional text (like Arabic and Hebrew) automatically.
	 * Some applications however, need some help to correctly handle bidirectional
	 * text.
	 * The PangoDirection type can be used with pango_context_set_base_dir() to
	 * instruct Pango about direction of text, though in most cases Pango detects
	 * that correctly and automatically. The rest of the facilities in this section
	 * are used internally by Pango already, and are provided to help applications
	 * that need more direct control over bidirectional setting of text.
	 */
	
	/**
	 * Breaks a piece of text into segments with consistent
	 * directional level and shaping engine. Each byte of text will
	 * be contained in exactly one of the items in the returned list;
	 * the generated list of items will be in logical order (the start
	 * offsets of the items are ascending).
	 * cached_iter should be an iterator over attrs currently positioned at a
	 * range before or containing start_index; cached_iter will be advanced to
	 * the range covering the position just after start_index + length.
	 * (i.e. if itemizing in a loop, just keep passing in the same cached_iter).
	 * Params:
	 * text =  the text to itemize.
	 * startIndex =  first byte in text to process
	 * length =  the number of bytes (not characters) to process
	 *  after start_index.
	 *  This must be >= 0.
	 * attrs =  the set of attributes that apply to text.
	 * cachedIter =  Cached attribute iterator, or NULL
	 * Returns: a GList of PangoItem structures.
	 */
	public ListG itemize(string text, int startIndex, int length, PgAttributeList attrs, PgAttributeIterator cachedIter);
	
	/**
	 * Like pango_itemize(), but the base direction to use when
	 * computing bidirectional levels (see pango_context_set_base_dir()),
	 * is specified explicitly rather than gotten from the PangoContext.
	 * Since 1.4
	 * Params:
	 * baseDir =  base direction to use for bidirectional processing
	 * text =  the text to itemize.
	 * startIndex =  first byte in text to process
	 * length =  the number of bytes (not characters) to process
	 *  after start_index.
	 *  This must be >= 0.
	 * attrs =  the set of attributes that apply to text.
	 * cachedIter =  Cached attribute iterator, or NULL
	 * Returns: a GList of PangoItem structures. The items should befreed using pango_item_free() probably in combination with g_list_foreach(),and the list itself using g_list_free().
	 */
	public ListG itemizeWithBaseDir(PangoDirection baseDir, string text, int startIndex, int length, PgAttributeList attrs, PgAttributeIterator cachedIter);
	
	/**
	 * From a list of items in logical order and the associated
	 * directional levels, produce a list in visual order.
	 * The original list is unmodified.
	 * Params:
	 * logicalItems =  a GList of PangoItem in logical order.
	 * Returns: a GList of PangoItem structures in visual order.(Please open a bug if you use this function. It is not a particularly convenient interface, and the code is duplicated elsewhere in Pango for that reason.)
	 */
	public static ListG reorderItems(ListG logicalItems);
	
	/**
	 * Creates a new PangoContext initialized to default values.
	 * This function is not particularly useful as it should always
	 * be followed by a pango_context_set_font_map() call, and the
	 * function pango_font_map_create_context() does these two steps
	 * together and hence users are recommended to use that.
	 * If you are using Pango as part of a higher-level system,
	 * that system may have it's own way of create a PangoContext.
	 * For instance, the GTK+ toolkit has, among others,
	 * gdk_pango_context_get_for_screen(), and
	 * gtk_widget_get_pango_context(). Use those instead.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Sets the font map to be searched when fonts are looked-up in this context.
	 * This is only for internal use by Pango backends, a PangoContext obtained
	 * via one of the recommended methods should already have a suitable font map.
	 * Params:
	 * fontMap =  the PangoFontMap to set.
	 */
	public void setFontMap(PgFontMap fontMap);
	
	/**
	 * Gets the PangoFontmap used to look up fonts for this context.
	 * Since 1.6
	 * Returns: the font map for the PangoContext. This value is owned by Pango and should not be unreferenced.
	 */
	public PgFontMap getFontMap();
	
	/**
	 * Retrieve the default font description for the context.
	 * Returns: a pointer to the context's default font description. This value must not be modified or freed.
	 */
	public PgFontDescription getFontDescription();
	
	/**
	 * Set the default font description for the context
	 * Params:
	 * desc =  the new pango font description
	 */
	public void setFontDescription(PgFontDescription desc);
	
	/**
	 * Retrieves the global language tag for the context.
	 * Returns: the global language tag.
	 */
	public PgLanguage getLanguage();
	
	/**
	 * Sets the global language tag for the context. The default language
	 * for the locale of the running process can be found using
	 * pango_language_get_default().
	 * Params:
	 * language =  the new language tag.
	 */
	public void setLanguage(PgLanguage language);
	
	/**
	 * Retrieves the base direction for the context. See
	 * pango_context_set_base_dir().
	 * Returns: the base direction for the context.
	 */
	public PangoDirection getBaseDir();
	
	/**
	 * Sets the base direction for the context.
	 * The base direction is used in applying the Unicode bidirectional
	 * algorithm; if the direction is PANGO_DIRECTION_LTR or
	 * PANGO_DIRECTION_RTL, then the value will be used as the paragraph
	 * direction in the Unicode bidirectional algorithm. A value of
	 * PANGO_DIRECTION_WEAK_LTR or PANGO_DIRECTION_WEAK_RTL is used only
	 * for paragraphs that do not contain any strong characters themselves.
	 * Params:
	 * direction =  the new base direction
	 */
	public void setBaseDir(PangoDirection direction);
	
	/**
	 * Retrieves the base gravity for the context. See
	 * pango_context_set_base_gravity().
	 * Since 1.16
	 * Returns: the base gravity for the context.
	 */
	public PangoGravity getBaseGravity();
	
	/**
	 * Sets the base gravity for the context.
	 * The base gravity is used in laying vertical text out.
	 * Since 1.16
	 * Params:
	 * gravity =  the new base gravity
	 */
	public void setBaseGravity(PangoGravity gravity);
	
	/**
	 * Retrieves the gravity for the context. This is similar to
	 * pango_context_get_base_gravity(), except for when the base gravity
	 * is PANGO_GRAVITY_AUTO for which pango_gravity_get_for_matrix() is used
	 * to return the gravity from the current context matrix.
	 * Since 1.16
	 * Returns: the resolved gravity for the context.
	 */
	public PangoGravity getGravity();
	
	/**
	 * Retrieves the gravity hint for the context. See
	 * pango_context_set_gravity_hint() for details.
	 * Since 1.16
	 * Returns: the gravity hint for the context.
	 */
	public PangoGravityHint getGravityHint();
	
	/**
	 * Sets the gravity hint for the context.
	 * The gravity hint is used in laying vertical text out, and is only relevant
	 * if gravity of the context as returned by pango_context_get_gravity()
	 * is set PANGO_GRAVITY_EAST or PANGO_GRAVITY_WEST.
	 * Since 1.16
	 * Params:
	 * hint =  the new gravity hint
	 */
	public void setGravityHint(PangoGravityHint hint);
	
	/**
	 * Gets the transformation matrix that will be applied when
	 * rendering with this context. See pango_context_set_matrix().
	 * Since 1.6
	 * Returns: the matrix, or NULL if no matrix has been set (which is the same as the identity matrix). The returned matrix is owned by Pango and must not be modified or freed.
	 */
	public PgMatrix getMatrix();
	
	/**
	 * Sets the transformation matrix that will be applied when rendering
	 * with this context. Note that reported metrics are in the user space
	 * coordinates before the application of the matrix, not device-space
	 * coordinates after the application of the matrix. So, they don't scale
	 * with the matrix, though they may change slightly for different
	 * matrices, depending on how the text is fit to the pixel grid.
	 * Since 1.6
	 * Params:
	 * matrix =  a PangoMatrix, or NULL to unset any existing matrix.
	 *  (No matrix set is the same as setting the identity matrix.)
	 */
	public void setMatrix(PgMatrix matrix);
	
	/**
	 * Loads the font in one of the fontmaps in the context
	 * that is the closest match for desc.
	 * Params:
	 * desc =  a PangoFontDescription describing the font to load
	 * Returns: the font loaded, or NULL if no font matched.
	 */
	public PgFont loadFont(PgFontDescription desc);
	
	/**
	 * Load a set of fonts in the context that can be used to render
	 * a font matching desc.
	 * Params:
	 * desc =  a PangoFontDescription describing the fonts to load
	 * language =  a PangoLanguage the fonts will be used for
	 * Returns: the fontset, or NULL if no font matched.
	 */
	public PgFontset loadFontset(PgFontDescription desc, PgLanguage language);
	
	/**
	 * Get overall metric information for a particular font
	 * description. Since the metrics may be substantially different for
	 * different scripts, a language tag can be provided to indicate that
	 * the metrics should be retrieved that correspond to the script(s)
	 * used by that language.
	 * The PangoFontDescription is interpreted in the same way as
	 * by pango_itemize(), and the family name may be a comma separated
	 * list of figures. If characters from multiple of these families
	 * would be used to render the string, then the returned fonts would
	 * be a composite of the metrics for the fonts loaded for the
	 * individual families.
	 * Params:
	 * desc =  a PangoFontDescription structure. NULL means that the font
	 * 	 description from the context will be used.
	 * language =  language tag used to determine which script to get the metrics
	 *  for. NULL means that the language tag from the context will
	 *  be used. If no language tag is set on the context, metrics
	 *  for the default language (as determined by
	 *  pango_language_get_default()) will be returned.
	 * Returns: a PangoFontMetrics object. The caller must call pango_font_metrics_unref() when finished using the object.
	 */
	public PgFontMetrics getMetrics(PgFontDescription desc, PgLanguage language);
	
	/**
	 * List all families for a context.
	 * Params:
	 * families =  location to store a pointer to an array of PangoFontFamily *.
	 *  This array should be freed with g_free().
	 */
	public void listFamilies(out PgFontFamily[] families);
	
	/**
	 * Computes a PangoLogAttr for each character in text. The log_attrs
	 * array must have one PangoLogAttr for each position in text; if
	 * text contains N characters, it has N+1 positions, including the
	 * last position at the end of the text. text should be an entire
	 * paragraph; logical attributes can't be computed without context
	 * (for example you need to see spaces on either side of a word to know
	 * the word is a word).
	 * Params:
	 * text =  text to process
	 * length =  length in bytes of text
	 * level =  embedding level, or -1 if unknown
	 * language =  language tag
	 * logAttrs =  array with one PangoLogAttr per character in text, plus one extra, to be filled in
	 * attrsLen =  length of log_attrs array
	 */
	public static void getLogAttrs(string text, int length, int level, PgLanguage language, PangoLogAttr* logAttrs, int attrsLen);
	
	/**
	 * Locates a paragraph boundary in text. A boundary is caused by
	 * delimiter characters, such as a newline, carriage return, carriage
	 * return-newline pair, or Unicode paragraph separator character. The
	 * index of the run of delimiters is returned in
	 * paragraph_delimiter_index. The index of the start of the paragraph
	 * (index after all delimiters) is stored in next_paragraph_start.
	 * If no delimiters are found, both paragraph_delimiter_index and
	 * next_paragraph_start are filled with the length of text (an index one
	 * off the end).
	 * Params:
	 * text =  UTF-8 text
	 * length =  length of text in bytes, or -1 if nul-terminated
	 * paragraphDelimiterIndex =  return location for index of delimiter
	 * nextParagraphStart =  return location for start of next paragraph
	 */
	public static void findParagraphBoundary(string text, int length, out int paragraphDelimiterIndex, out int nextParagraphStart);
	
	/**
	 * This is the default break algorithm, used if no language
	 * engine overrides it. Normally you should use pango_break()
	 * instead. Unlike pango_break(),
	 * analysis can be NULL, but only do that if you know what
	 * you're doing. If you need an analysis to pass to pango_break(),
	 * you need to pango_itemize(). In most cases however you should
	 * simply use pango_get_log_attrs().
	 * Params:
	 * text =  text to break
	 * length =  length of text in bytes (may be -1 if text is nul-terminated)
	 * analysis =  a PangoAnalysis for the text
	 * attrs =  logical attributes to fill in
	 * attrsLen =  size of the array passed as attrs
	 */
	public static void defaultBreak(string text, int length, PangoAnalysis* analysis, PangoLogAttr* attrs, int attrsLen);
	
	/**
	 * Given a segment of text and the corresponding
	 * PangoAnalysis structure returned from pango_itemize(),
	 * convert the characters into glyphs. You may also pass
	 * in only a substring of the item from pango_itemize().
	 * Params:
	 * text =  the text to process
	 * length =  the length (in bytes) of text
	 * analysis =  PangoAnalysis structure from pango_itemize()
	 * glyphs =  glyph string in which to store results
	 */
	public static void shape(string text, int length, PangoAnalysis* analysis, PgGlyphString glyphs);
	
	/**
	 * Determines the inherent direction of a character; either
	 * PANGO_DIRECTION_LTR, PANGO_DIRECTION_RTL, or
	 * PANGO_DIRECTION_NEUTRAL.
	 * This function is useful to categorize characters into left-to-right
	 * letters, right-to-left letters, and everything else. If full
	 * Unicode bidirectional type of a character is needed,
	 * pango_bidi_type_for_gunichar() can be used instead.
	 * Params:
	 * ch =  a Unicode character
	 * Returns: the direction of the character.
	 */
	public static PangoDirection unicharDirection(gunichar ch);
	
	/**
	 * Searches a string the first character that has a strong
	 * direction, according to the Unicode bidirectional algorithm.
	 * Since 1.4
	 * Params:
	 * text =  the text to process
	 * length =  length of text in bytes (may be -1 if text is nul-terminated)
	 * Returns: The direction corresponding to the first strong character.If no such character is found, then PANGO_DIRECTION_NEUTRAL is returned.
	 */
	public static PangoDirection findBaseDir(string text, int length);
	
	/**
	 * Warning
	 * pango_get_mirror_char is deprecated and should not be used in newly-written code.
	 * If ch has the Unicode mirrored property and there is another Unicode
	 * character that typically has a glyph that is the mirror image of ch's
	 * glyph, puts that character in the address pointed to by mirrored_ch.
	 * Use g_unichar_get_mirror_char() instead; the docs for that function
	 * provide full details.
	 * Params:
	 * ch =  a Unicode character
	 * mirroredCh =  location to store the mirrored character
	 * Returns: TRUE if ch has a mirrored character and mirrored_ch isfilled in, FALSE otherwise
	 */
	public static int getMirrorChar(gunichar ch, gunichar* mirroredCh);
	
	/**
	 * Determines the normative bidirectional character type of a
	 * character, as specified in the Unicode Character Database.
	 * A simplified version of this function is available as
	 * pango_unichar_get_direction().
	 * Since 1.22
	 * Params:
	 * ch =  a Unicode character
	 * Returns: the bidirectional character type, as used in theUnicode bidirectional algorithm.
	 */
	public static PangoBidiType bidiTypeForUnichar(gunichar ch);
}
