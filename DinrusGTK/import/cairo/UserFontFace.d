module gtkD.cairo.UserFontFace;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * The user-font feature allows the cairo user to provide drawings for glyphs
 * in a font. This is most useful in implementing fonts in non-standard
 * formats, like SVG fonts and Flash fonts, but can also be used by games and
 * other application to draw "funky" fonts.
 */
public class UserFontFace
{
	
	/** the main Gtk struct */
	protected cairo_font_face_t* cairo_font_face;
	
	
	public cairo_font_face_t* getUserFontFaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_font_face_t* cairo_font_face);
	
	/**
	 */
	
	/**
	 * Creates a new user font-face.
	 * Use the setter functions to associate callbacks with the returned
	 * user font. The only mandatory callback is render_glyph.
	 * After the font-face is created, the user can attach arbitrary data
	 * (the actual font data) to it using cairo_font_face_set_user_data()
	 * and access it from the user-font callbacks by using
	 * cairo_scaled_font_get_font_face() followed by
	 * cairo_font_face_get_user_data().
	 * Since 1.8
	 * Returns: a newly created cairo_font_face_t. Free with cairo_font_face_destroy() when you are done using it.
	 */
	public static UserFontFace create();
	
	/**
	 * Sets the scaled-font initialization function of a user-font.
	 * See cairo_user_scaled_font_init_func_t for details of how the callback
	 * works.
	 * The font-face should not be immutable or a CAIRO_STATUS_USER_FONT_IMMUTABLE
	 * error will occur. A user font-face is immutable as soon as a scaled-font
	 * is created from it.
	 * Since 1.8
	 * Params:
	 * initFunc =  The init callback, or NULL
	 */
	public void setInitFunc(cairo_user_scaled_font_init_func_t initFunc);
	
	/**
	 * Gets the scaled-font initialization function of a user-font.
	 * Since 1.8
	 * Returns: The init callback of font_faceor NULL if none set.
	 */
	public cairo_user_scaled_font_init_func_t getInitFunc();
	
	/**
	 * Sets the glyph rendering function of a user-font.
	 * See cairo_user_scaled_font_render_glyph_func_t for details of how the callback
	 * works.
	 * The font-face should not be immutable or a CAIRO_STATUS_USER_FONT_IMMUTABLE
	 * error will occur. A user font-face is immutable as soon as a scaled-font
	 * is created from it.
	 * The render_glyph callback is the only mandatory callback of a user-font.
	 * If the callback is NULL and a glyph is tried to be rendered using
	 * font_face, a CAIRO_STATUS_USER_FONT_ERROR will occur.
	 * Since 1.8
	 * Params:
	 * renderGlyphFunc =  The render_glyph callback, or NULL
	 */
	public void setRenderGlyphFunc(cairo_user_scaled_font_render_glyph_func_t renderGlyphFunc);
	
	/**
	 * Gets the glyph rendering function of a user-font.
	 * Since 1.8
	 * Returns: The render_glyph callback of font_faceor NULL if none set.
	 */
	public cairo_user_scaled_font_render_glyph_func_t getRenderGlyphFunc();
	
	/**
	 * Sets the unicode-to-glyph conversion function of a user-font.
	 * See cairo_user_scaled_font_unicode_to_glyph_func_t for details of how the callback
	 * works.
	 * The font-face should not be immutable or a CAIRO_STATUS_USER_FONT_IMMUTABLE
	 * error will occur. A user font-face is immutable as soon as a scaled-font
	 * is created from it.
	 * Since 1.8
	 * Params:
	 * unicodeToGlyphFunc =  The unicode_to_glyph callback, or NULL
	 */
	public void setUnicodeToGlyphFunc(cairo_user_scaled_font_unicode_to_glyph_func_t unicodeToGlyphFunc);
	
	/**
	 * Gets the unicode-to-glyph conversion function of a user-font.
	 * Since 1.8
	 * Returns: The unicode_to_glyph callback of font_faceor NULL if none set.
	 */
	public cairo_user_scaled_font_unicode_to_glyph_func_t getUnicodeToGlyphFunc();
	
	/**
	 * Sets th text-to-glyphs conversion function of a user-font.
	 * See cairo_user_scaled_font_text_to_glyphs_func_t for details of how the callback
	 * works.
	 * The font-face should not be immutable or a CAIRO_STATUS_USER_FONT_IMMUTABLE
	 * error will occur. A user font-face is immutable as soon as a scaled-font
	 * is created from it.
	 * Since 1.8
	 * Params:
	 * textToGlyphsFunc =  The text_to_glyphs callback, or NULL
	 */
	public void setTextToGlyphsFunc(cairo_user_scaled_font_text_to_glyphs_func_t textToGlyphsFunc);
	
	/**
	 * Gets the text-to-glyphs conversion function of a user-font.
	 * Since 1.8
	 * Returns: The text_to_glyphs callback of font_faceor NULL if none set.
	 */
	public cairo_user_scaled_font_text_to_glyphs_func_t getTextToGlyphsFunc();
}
