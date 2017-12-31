module gtkD.cairo.FontFace;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * cairo_font_face_t represents a particular font at a particular weight,
 * slant, and other characteristic but no size, transformation, or size.
 * Font faces are created using font-backend-specific
 * constructors, typically of the form
 * cairo_backend_font_face_create(),
 * or implicitly using the toy text API by way of
 * cairo_select_font_face(). The resulting face can be accessed using
 * cairo_get_font_face().
 */
public class FontFace
{
	
	/** the main Gtk struct */
	protected cairo_font_face_t* cairo_font_face;
	
	
	public cairo_font_face_t* getFontFaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_font_face_t* cairo_font_face);
	
	/**
	 */
	
	/**
	 * Increases the reference count on font_face by one. This prevents
	 * font_face from being destroyed until a matching call to
	 * cairo_font_face_destroy() is made.
	 * The number of references to a cairo_font_face_t can be get using
	 * cairo_font_face_get_reference_count().
	 * Returns: the referenced cairo_font_face_t.
	 */
	public FontFace reference();
	
	/**
	 * Decreases the reference count on font_face by one. If the result
	 * is zero, then font_face and all associated resources are freed.
	 * See cairo_font_face_reference().
	 */
	public void destroy();
	
	/**
	 * Checks whether an error has previously occurred for this
	 * font face
	 * Returns: CAIRO_STATUS_SUCCESS or another error such as CAIRO_STATUS_NO_MEMORY.
	 */
	public cairo_status_t status();
	
	/**
	 * This function returns the type of the backend used to create
	 * a font face. See cairo_font_type_t for available types.
	 * Since 1.2
	 * Returns: The type of font_face.
	 */
	public cairo_font_type_t getType();
	
	/**
	 * Returns the current reference count of font_face.
	 * Since 1.4
	 * Returns: the current reference count of font_face. If theobject is a nil object, 0 will be returned.
	 */
	public uint getReferenceCount();
	
	/**
	 * Attach user data to font_face. To remove user data from a font face,
	 * call this function with the key that was used to set it and NULL
	 * for data.
	 * Params:
	 * key =  the address of a cairo_user_data_key_t to attach the user data to
	 * userData =  the user data to attach to the font face
	 * destroy =  a cairo_destroy_func_t which will be called when the
	 * font face is destroyed or when new user data is attached using the
	 * same key.
	 * Returns: CAIRO_STATUS_SUCCESS or CAIRO_STATUS_NO_MEMORY if aslot could not be allocated for the user data.
	 */
	public cairo_status_t setUserData(cairo_user_data_key_t* key, void* userData, cairo_destroy_func_t destroy);
	
	/**
	 * Return user data previously attached to font_face using the specified
	 * key. If no user data has been attached with the given key this
	 * function returns NULL.
	 * Params:
	 * key =  the address of the cairo_user_data_key_t the user data was
	 * attached to
	 * Returns: the user data previously attached or NULL.
	 */
	public void* getUserData(cairo_user_data_key_t* key);
}
