module gtkD.cairo.Surface;

public  import gtkD.gtkc.cairotypes;

private import gtkD.gtkc.cairo;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.cairo.FontOption;




/**
 * Description
 * cairo_surface_t is the abstract type representing all different drawing
 * targets that cairo can render to. The actual drawings are
 * performed using a cairo context.
 * A cairo surface is created by using backend-specific
 * constructors, typically of the form
 * cairo_backend_surface_create().
 */
public class Surface
{
	
	/** the main Gtk struct */
	protected cairo_surface_t* cairo_surface;
	
	
	public cairo_surface_t* getSurfaceStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (cairo_surface_t* cairo_surface);
	
	/**
	 */
	
	/**
	 * Create a new surface that is as compatible as possible with an
	 * existing surface. For example the new surface will have the same
	 * fallback resolution and font options as other. Generally, the new
	 * surface will also use the same backend as other, unless that is
	 * not possible for some reason. The type of the returned surface may
	 * be examined with cairo_surface_get_type().
	 * Initially the surface contents are all 0 (transparent if contents
	 * have transparency, black otherwise.)
	 * Params:
	 * content =  the content for the new surface
	 * width =  width of the new surface, (in device-space units)
	 * height =  height of the new surface (in device-space units)
	 * Returns: a pointer to the newly allocated surface. The callerowns the surface and should call cairo_surface_destroy() when donewith it.This function always returns a valid pointer, but it will return apointer to a "nil" surface if other is already in an error stateor any other error occurs.
	 */
	public Surface createSimilar(cairo_content_t content, int width, int height);
	
	/**
	 * Increases the reference count on surface by one. This prevents
	 * surface from being destroyed until a matching call to
	 * cairo_surface_destroy() is made.
	 * The number of references to a cairo_surface_t can be get using
	 * cairo_surface_get_reference_count().
	 * Returns: the referenced cairo_surface_t.
	 */
	public Surface reference();
	
	/**
	 * Decreases the reference count on surface by one. If the result is
	 * zero, then surface and all associated resources are freed. See
	 * cairo_surface_reference().
	 */
	public void destroy();
	
	/**
	 * Checks whether an error has previously occurred for this
	 * surface.
	 * Returns: CAIRO_STATUS_SUCCESS, CAIRO_STATUS_NULL_POINTER,CAIRO_STATUS_NO_MEMORY, CAIRO_STATUS_READ_ERROR,CAIRO_STATUS_INVALID_CONTENT, CAIRO_STATUS_INVALID_FORMAT, orCAIRO_STATUS_INVALID_VISUAL.
	 */
	public cairo_status_t status();
	
	/**
	 * This function finishes the surface and drops all references to
	 * external resources. For example, for the Xlib backend it means
	 * that cairo will no longer access the drawable, which can be freed.
	 * After calling cairo_surface_finish() the only valid operations on a
	 * surface are getting and setting user, referencing and
	 * destroying, and flushing and finishing it.
	 * Further drawing to the surface will not affect the
	 * surface but will instead trigger a CAIRO_STATUS_SURFACE_FINISHED
	 * error.
	 * When the last call to cairo_surface_destroy() decreases the
	 * reference count to zero, cairo will call cairo_surface_finish() if
	 * it hasn't been called already, before freeing the resources
	 * associated with the surface.
	 */
	public void finish();
	
	/**
	 * Do any pending drawing for the surface and also restore any
	 * temporary modification's cairo has made to the surface's
	 * state. This function must be called before switching from
	 * drawing on the surface with cairo to drawing on it directly
	 * with native APIs. If the surface doesn't support direct access,
	 * then this function does nothing.
	 */
	public void flush();
	
	/**
	 * Retrieves the default font rendering options for the surface.
	 * This allows display surfaces to report the correct subpixel order
	 * for rendering on them, print surfaces to disable hinting of
	 * metrics and so forth. The result can then be used with
	 * cairo_scaled_font_create().
	 * Params:
	 * options =  a cairo_font_options_t object into which to store
	 *  the retrieved options. All existing values are overwritten
	 */
	public void getFontOptions(FontOption options);
	
	/**
	 * This function returns the content type of surface which indicates
	 * whether the surface contains color and/or alpha information. See
	 * cairo_content_t.
	 * Since 1.2
	 * Returns: The content type of surface.
	 */
	public cairo_content_t getContent();
	
	/**
	 * Tells cairo that drawing has been done to surface using means other
	 * than cairo, and that cairo should reread any cached areas. Note
	 * that you must call cairo_surface_flush() before doing such drawing.
	 */
	public void markDirty();
	
	/**
	 * Like cairo_surface_mark_dirty(), but drawing has been done only to
	 * the specified rectangle, so that cairo can retain cached contents
	 * for other parts of the surface.
	 * Any cached clip set on the surface will be reset by this function,
	 * to make sure that future cairo calls have the clip set that they
	 * expect.
	 * Params:
	 * x =  X coordinate of dirty rectangle
	 * y =  Y coordinate of dirty rectangle
	 * width =  width of dirty rectangle
	 * height =  height of dirty rectangle
	 */
	public void markDirtyRectangle(int x, int y, int width, int height);
	
	/**
	 * Sets an offset that is added to the device coordinates determined
	 * by the CTM when drawing to surface. One use case for this function
	 * is when we want to create a cairo_surface_t that redirects drawing
	 * for a portion of an onscreen surface to an offscreen surface in a
	 * way that is completely invisible to the user of the cairo
	 * API. Setting a transformation via cairo_translate() isn't
	 * sufficient to do this, since functions like
	 * cairo_device_to_user() will expose the hidden offset.
	 * Note that the offset affects drawing to the surface as well as
	 * using the surface in a source pattern.
	 * Params:
	 * xOffset =  the offset in the X direction, in device units
	 * yOffset =  the offset in the Y direction, in device units
	 */
	public void setDeviceOffset(double xOffset, double yOffset);
	
	/**
	 * This function returns the previous device offset set by
	 * cairo_surface_set_device_offset().
	 * Since 1.2
	 * Params:
	 * xOffset =  the offset in the X direction, in device units
	 * yOffset =  the offset in the Y direction, in device units
	 */
	public void getDeviceOffset(out double xOffset, out double yOffset);
	
	/**
	 * Set the horizontal and vertical resolution for image fallbacks.
	 * When certain operations aren't supported natively by a backend,
	 * cairo will fallback by rendering operations to an image and then
	 * overlaying that image onto the output. For backends that are
	 * natively vector-oriented, this function can be used to set the
	 * resolution used for these image fallbacks, (larger values will
	 * result in more detailed images, but also larger file sizes).
	 * Some examples of natively vector-oriented backends are the ps, pdf,
	 * and svg backends.
	 * For backends that are natively raster-oriented, image fallbacks are
	 * still possible, but they are always performed at the native
	 * device resolution. So this function has no effect on those
	 * backends.
	 * Note: The fallback resolution only takes effect at the time of
	 * completing a page (with cairo_show_page() or cairo_copy_page()) so
	 * there is currently no way to have more than one fallback resolution
	 * in effect on a single page.
	 * The default fallback resoultion is 300 pixels per inch in both
	 * dimensions.
	 * Since 1.2
	 * Params:
	 * xPixelsPerInch =  horizontal setting for pixels per inch
	 * yPixelsPerInch =  vertical setting for pixels per inch
	 */
	public void setFallbackResolution(double xPixelsPerInch, double yPixelsPerInch);
	
	/**
	 * This function returns the previous fallback resolution set by
	 * cairo_surface_set_fallback_resolution(), or default fallback
	 * resolution if never set.
	 * Since 1.8
	 * Params:
	 * xPixelsPerInch =  horizontal pixels per inch
	 * yPixelsPerInch =  vertical pixels per inch
	 */
	public void getFallbackResolution(out double xPixelsPerInch, out double yPixelsPerInch);
	
	/**
	 * This function returns the type of the backend used to create
	 * a surface. See cairo_surface_type_t for available types.
	 * Since 1.2
	 * Params:
	 * surface =  a cairo_surface_t
	 * Returns: The type of surface.
	 */
	public cairo_surface_type_t getType();
	/**
	 * Returns the current reference count of surface.
	 * Since 1.4
	 * Returns: the current reference count of surface. If theobject is a nil object, 0 will be returned.
	 */
	public uint getReferenceCount();
	
	/**
	 * Attach user data to surface. To remove user data from a surface,
	 * call this function with the key that was used to set it and NULL
	 * for data.
	 * Params:
	 * key =  the address of a cairo_user_data_key_t to attach the user data to
	 * userData =  the user data to attach to the surface
	 * destroy =  a cairo_destroy_func_t which will be called when the
	 * surface is destroyed or when new user data is attached using the
	 * same key.
	 * Returns: CAIRO_STATUS_SUCCESS or CAIRO_STATUS_NO_MEMORY if aslot could not be allocated for the user data.
	 */
	public cairo_status_t setUserData(cairo_user_data_key_t* key, void* userData, cairo_destroy_func_t destroy);
	
	/**
	 * Return user data previously attached to surface using the specified
	 * key. If no user data has been attached with the given key this
	 * function returns NULL.
	 * Params:
	 * key =  the address of the cairo_user_data_key_t the user data was
	 * attached to
	 * Returns: the user data previously attached or NULL.
	 */
	public void* getUserData(cairo_user_data_key_t* key);
	
	/**
	 * Emits the current page for backends that support multiple pages,
	 * but doesn't clear it, so that the contents of the current page will
	 * be retained for the next page. Use cairo_surface_show_page() if you
	 * want to get an empty page after the emission.
	 * There is a convenience function for this that takes a cairo_t,
	 * namely cairo_copy_page().
	 * Since 1.6
	 */
	public void copyPage();
	
	/**
	 * Emits and clears the current page for backends that support multiple
	 * pages. Use cairo_surface_copy_page() if you don't want to clear the page.
	 * There is a convenience function for this that takes a cairo_t,
	 * namely cairo_show_page().
	 * Since 1.6
	 */
	public void showPage();
	
	/**
	 * Returns whether the surface supports
	 * sophisticated cairo_show_text_glyphs() operations. That is,
	 * whether it actually uses the provided text and cluster data
	 * to a cairo_show_text_glyphs() call.
	 * Note: Even if this function returns FALSE, a
	 * cairo_show_text_glyphs() operation targeted at surface will
	 * still succeed. It just will
	 * act like a cairo_show_glyphs() operation. Users can use this
	 * function to avoid computing UTF-8 text and cluster mapping if the
	 * target surface does not use it.
	 * There is a convenience function for this that takes a cairo_t,
	 * namely cairo_has_show_text_glyphs().
	 * Since 1.8
	 * Returns: TRUE if surface supports cairo_show_text_glyphs(), FALSE otherwise
	 */
	public cairo_bool_t hasShowTextGlyphs();
}
