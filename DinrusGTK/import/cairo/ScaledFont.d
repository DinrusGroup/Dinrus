module gtkD.cairo.ScaledFont;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.cairo.FontFace;
private import gtkD.cairo.FontOption;
private import gtkD.cairo.Matrix;
private import gtkD.glib.Str;




/**
 * Description
 * cairo_scaled_font_t represents a realization of a font face at a particular
 * size and transformation and a certain set of font options.
 */
public class ScaledFont
{
	
	/** the main Gtk struct */
	protected cairo_scaled_font_t* cairo_scaled_font;
	
	
	public cairo_scaled_font_t* getScaledFontStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_scaled_font_t* cairo_scaled_font);
	
	/**
	 */
	
	/**
	 * Creates a cairo_scaled_font_t object from a font face and matrices that
	 * describe the size of the font and the environment in which it will
	 * be used.
	 * Params:
	 * fontFace =  a cairo_font_face_t
	 * fontMatrix =  font space to user space transformation matrix for the
	 *  font. In the simplest case of a N point font, this matrix is
	 *  just a scale by N, but it can also be used to shear the font
	 *  or stretch it unequally along the two axes. See
	 *  cairo_set_font_matrix().
	 * ctm =  user to device transformation matrix with which the font will
	 *  be used.
	 * options =  options to use when getting metrics for the font and
	 *  rendering with it. A NULL pointer will be interpreted as
	 *  meaning the default options.
	 * Returns: a newly created cairo_scaled_font_t. Destroy with cairo_scaled_font_destroy()
	 */
	public static ScaledFont create(FontFace fontFace, Matrix fontMatrix, Matrix ctm, FontOption options);
	
	/**
	 * Increases the reference count on scaled_font by one. This prevents
	 * scaled_font from being destroyed until a matching call to
	 * cairo_scaled_font_destroy() is made.
	 * The number of references to a cairo_scaled_font_t can be get using
	 * cairo_scaled_font_get_reference_count().
	 * Returns: the referenced cairo_scaled_font_t
	 */
	public ScaledFont reference();
	
	/**
	 * Decreases the reference count on font by one. If the result
	 * is zero, then font and all associated resources are freed.
	 * See cairo_scaled_font_reference().
	 */
	public void destroy();
	
	/**
	 * Checks whether an error has previously occurred for this
	 * scaled_font.
	 * Returns: CAIRO_STATUS_SUCCESS or another error such as CAIRO_STATUS_NO_MEMORY.
	 */
	public cairo_status_t status();
	
	/**
	 * Gets the metrics for a cairo_scaled_font_t.
	 * Params:
	 * extents =  a cairo_font_extents_t which to store the retrieved extents.
	 */
	public void extents(cairo_font_extents_t* extents);
	
	/**
	 * Gets the extents for a string of text. The extents describe a
	 * user-space rectangle that encloses the "inked" portion of the text
	 * drawn at the origin (0,0) (as it would be drawn by cairo_show_text()
	 * if the cairo graphics state were set to the same font_face,
	 * font_matrix, ctm, and font_options as scaled_font). Additionally,
	 * the x_advance and y_advance values indicate the amount by which the
	 * current point would be advanced by cairo_show_text().
	 * Note that whitespace characters do not directly contribute to the
	 * size of the rectangle (extents.width and extents.height). They do
	 * contribute indirectly by changing the position of non-whitespace
	 * characters. In particular, trailing whitespace characters are
	 * likely to not affect the size of the rectangle, though they will
	 * affect the x_advance and y_advance values.
	 * Since 1.2
	 * Params:
	 * utf8 =  a NUL-terminated string of text, encoded in UTF-8
	 * extents =  a cairo_text_extents_t which to store the retrieved extents.
	 */
	public void textExtents(string utf8, cairo_text_extents_t* extents);
	
	/**
	 * Gets the extents for an array of glyphs. The extents describe a
	 * user-space rectangle that encloses the "inked" portion of the
	 * glyphs, (as they would be drawn by cairo_show_glyphs() if the cairo
	 * graphics state were set to the same font_face, font_matrix, ctm,
	 * and font_options as scaled_font). Additionally, the x_advance and
	 * y_advance values indicate the amount by which the current point
	 * would be advanced by cairo_show_glyphs().
	 * Note that whitespace glyphs do not contribute to the size of the
	 * rectangle (extents.width and extents.height).
	 * Params:
	 * glyphs =  an array of glyph IDs with X and Y offsets.
	 * numGlyphs =  the number of glyphs in the glyphs array
	 * extents =  a cairo_text_extents_t which to store the retrieved extents.
	 */
	public void glyphExtents(cairo_glyph_t* glyphs, int numGlyphs, cairo_text_extents_t* extents);
	
	/**
	 * Converts UTF-8 text to an array of glyphs, optionally with cluster
	 * mapping, that can be used to render later using scaled_font.
	 * If glyphs initially points to a non-NULL value, that array is used
	 * as a glyph buffer, and num_glyphs should point to the number of glyph
	 * entries available there. If the provided glyph array is too short for
	 * the conversion, a new glyph array is allocated using cairo_glyph_allocate()
	 * and placed in glyphs. Upon return, num_glyphs always contains the
	 * number of generated glyphs. If the value glyphs points at has changed
	 * after the call, the user is responsible for freeing the allocated glyph
	 * array using cairo_glyph_free().
	 * If clusters is not NULL, num_clusters and cluster_flags should not be NULL,
	 * and cluster mapping will be computed.
	 * The semantics of how cluster array allocation works is similar to the glyph
	 * array. That is,
	 * if clusters initially points to a non-NULL value, that array is used
	 * as a cluster buffer, and num_clusters should point to the number of cluster
	 * entries available there. If the provided cluster array is too short for
	 * the conversion, a new cluster array is allocated using cairo_text_cluster_allocate()
	 * and placed in clusters. Upon return, num_clusters always contains the
	 * number of generated clusters. If the value clusters points at has changed
	 * after the call, the user is responsible for freeing the allocated cluster
	 * array using cairo_text_cluster_free().
	 * In the simplest case, glyphs and clusters can point to NULL initially
	 * Since 1.8
	 * Params:
	 * x =  X position to place first glyph
	 * y =  Y position to place first glyph
	 * utf8 =  a string of text encoded in UTF-8
	 * utf8_Len =  length of utf8 in bytes, or -1 if it is NUL-terminated
	 * glyphs =  pointer to array of glyphs to fill
	 * clusters =  pointer to array of cluster mapping information to fill, or NULL
	 * clusterFlags =  pointer to location to store cluster flags corresponding to the
	 *  output clusters, or NULL
	 * Returns: CAIRO_STATUS_SUCCESS upon success, or an error statusif the input values are wrong or if conversion failed. If the inputvalues are correct but the conversion failed, the error status is alsoset on scaled_font.
	 */
	public cairo_status_t textToGlyphs(double x, double y, string utf8, int utf8_Len, out cairo_glyph_t[] glyphs, out cairo_text_cluster_t[] clusters, out cairo_text_cluster_flags_t clusterFlags);
	
	/**
	 * Gets the font face that this scaled font was created for.
	 * Since 1.2
	 * Returns: The cairo_font_face_t with which scaled_font wascreated.
	 */
	public FontFace getFontFace();
	
	/**
	 * Stores the font options with which scaled_font was created into
	 * options.
	 * Since 1.2
	 * Params:
	 * options =  return value for the font options
	 */
	public void getFontOptions(FontOption options);
	
	/**
	 * Stores the font matrix with which scaled_font was created into
	 * matrix.
	 * Since 1.2
	 * Params:
	 * fontMatrix =  return value for the matrix
	 */
	public void getFontMatrix(Matrix fontMatrix);
	
	/**
	 * Stores the CTM with which scaled_font was created into ctm.
	 * Since 1.2
	 * Params:
	 * ctm =  return value for the CTM
	 */
	public void getCtm(Matrix ctm);
	
	/**
	 * Stores the scale matrix of scaled_font into matrix.
	 * The scale matrix is product of the font matrix and the ctm
	 * associated with the scaled font, and hence is the matrix mapping from
	 * font space to device space.
	 * Since 1.8
	 * Params:
	 * scaleMatrix =  return value for the matrix
	 */
	public void getScaleMatrix(Matrix scaleMatrix);
	
	/**
	 * This function returns the type of the backend used to create
	 * a scaled font. See cairo_font_type_t for available types.
	 * Since 1.2
	 * Returns: The type of scaled_font.
	 */
	public cairo_font_type_t getType();
	
	/**
	 * Returns the current reference count of scaled_font.
	 * Since 1.4
	 * Returns: the current reference count of scaled_font. If theobject is a nil object, 0 will be returned.
	 */
	public uint getReferenceCount();
	
	/**
	 * Attach user data to scaled_font. To remove user data from a surface,
	 * call this function with the key that was used to set it and NULL
	 * for data.
	 * Since 1.4
	 * Params:
	 * key =  the address of a cairo_user_data_key_t to attach the user data to
	 * userData =  the user data to attach to the cairo_scaled_font_t
	 * destroy =  a cairo_destroy_func_t which will be called when the
	 * cairo_t is destroyed or when new user data is attached using the
	 * same key.
	 * Returns: CAIRO_STATUS_SUCCESS or CAIRO_STATUS_NO_MEMORY if aslot could not be allocated for the user data.
	 */
	public cairo_status_t setUserData(cairo_user_data_key_t* key, void* userData, cairo_destroy_func_t destroy);
	
	/**
	 * Return user data previously attached to scaled_font using the
	 * specified key. If no user data has been attached with the given
	 * key this function returns NULL.
	 * Since 1.4
	 * Params:
	 * key =  the address of the cairo_user_data_key_t the user data was
	 * attached to
	 * Returns: the user data previously attached or NULL.
	 */
	public void* getUserData(cairo_user_data_key_t* key);
}
