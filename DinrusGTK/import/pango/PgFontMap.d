module gtkD.pango.PgFontMap;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgFont;
private import gtkD.pango.PgFontset;
private import gtkD.pango.PgContext;
private import gtkD.pango.PgFontDescription;
private import gtkD.pango.PgLanguage;
private import gtkD.pango.PgFontFamily;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * Pango supports a flexible architecture where a
 * particular rendering architecture can supply an
 * implementation of fonts. The PangoFont structure
 * represents an abstract rendering-system-independent font.
 * Pango provides routines to list available fonts, and
 * to load a font of a given description.
 */
public class PgFontMap : ObjectG
{
	
	/** the main Gtk struct */
	protected PangoFontMap* pangoFontMap;
	
	
	public PangoFontMap* getPgFontMapStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (PangoFontMap* pangoFontMap);
	
	/**
	 */
	
	/**
	 * Creates a PangoContext connected to fontmap. This is equivalent
	 * to pango_context_new() followed by pango_context_set_font_map().
	 * If you are using Pango as part of a higher-level system,
	 * that system may have it's own way of create a PangoContext.
	 * For instance, the GTK+ toolkit has, among others,
	 * gdk_pango_context_get_for_screen(), and
	 * gtk_widget_get_pango_context(). Use those instead.
	 * Since 1.22
	 * Returns: the newly allocated PangoContext, which should be freed with g_object_unref().
	 */
	public PgContext createContext();
	
	/**
	 * Load the font in the fontmap that is the closest match for desc.
	 * Params:
	 * context =  the PangoContext the font will be used with
	 * desc =  a PangoFontDescription describing the font to load
	 * Returns: the font loaded, or NULL if no font matched.
	 */
	public PgFont loadFont(PgContext context, PgFontDescription desc);
	
	/**
	 * Load a set of fonts in the fontmap that can be used to render
	 * a font matching desc.
	 * Params:
	 * context =  the PangoContext the font will be used with
	 * desc =  a PangoFontDescription describing the font to load
	 * language =  a PangoLanguage the fonts will be used for
	 * Returns: the fontset, or NULL if no font matched.
	 */
	public PgFontset loadFontset(PgContext context, PgFontDescription desc, PgLanguage language);

	/**
	 * List all families for a fontmap.
	 * Params:
	 * families =  location to store a pointer to an array of PangoFontFamily *.
	 *  This array should be freed with g_free().
	 */
	public void listFamilies(out PgFontFamily[] families);
	
	/**
	 * Returns the render ID for shape engines for this fontmap.
	 * See the render_type field of
	 * PangoEngineInfo.
	 * Since 1.4
	 * Returns: the ID string for shape engines for this fontmap. Owned by Pango, should not be modified or freed.
	 */
	public string getShapeEngineType();
}
