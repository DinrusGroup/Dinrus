module gtkD.pango.PgScript;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.pango.PgLanguage;




/**
 * Description
 * The functions in this section are used to identify the writing
 * system, or script of individual characters
 * and of ranges within a larger text string.
 */
public class PgScript
{
	
	/**
	 */
	
	/**
	 * Looks up the PangoScript for a particular character (as defined by
	 * Unicode Standard Annex 24). No check is made for ch being a
	 * valid Unicode character; if you pass in invalid character, the
	 * result is undefined.
	 * As of Pango 1.18, this function simply returns the return value of
	 * g_unichar_get_script().
	 * Since 1.4
	 * Params:
	 * ch =  a Unicode character
	 * Returns: the PangoScript for the character.
	 */
	public static PangoScript scriptForUnichar(gunichar ch);
	
	/**
	 * Given a script, finds a language tag that is reasonably
	 * representative of that script. This will usually be the
	 * Since 1.4
	 * Params:
	 * script =  a PangoScript
	 * Returns: a PangoLanguage that is representativeof the script, or NULL if no such language exists.
	 */
	public static PgLanguage scriptGetSampleLanguage(PangoScript script);
}
