module gtkD.glgdk.GLFont;

public  import gtkD.gtkglc.glgdktypes;

private import gtkD.gtkglc.glgdk;
private import gtkD.glib.ConstructionException;


private import gtkD.gdk.Display;
private import gtkD.pango.PgFont;
private import gtkD.pango.PgFontDescription;




/**
 * Description
 */
public class GLFont
{
	
	/**
	 */
	
	/**
	 * Creates bitmap display lists from a PangoFont.
	 * Params:
	 * fontDesc =  a PangoFontDescription describing the font to use.
	 * first =  the index of the first glyph to be taken.
	 * count =  the number of glyphs to be taken.
	 * listBase =  the index of the first display list to be generated.
	 * Returns: the PangoFont used, or NULL if no font matched.
	 */
	public static PgFont usePangoFont(PgFontDescription fontDesc, int first, int count, int listBase);
	
	/**
	 * Creates bitmap display lists from a PangoFont.
	 * Params:
	 * display =  a GdkDisplay.
	 * fontDesc =  a PangoFontDescription describing the font to use.
	 * first =  the index of the first glyph to be taken.
	 * count =  the number of glyphs to be taken.
	 * listBase =  the index of the first display list to be generated.
	 * Returns: the PangoFont used, or NULL if no font matched.<<OpenGL WindowGeometric Object Rendering>>
	 */
	public static PgFont usePangoFontForDisplay(Display display, PgFontDescription fontDesc, int first, int count, int listBase);
}
