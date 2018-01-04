module gtkD.glib.Pattern;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * The g_pattern_match* functions match a string
 * against a pattern containing '*' and '?' wildcards with similar semantics
 * as the standard glob() function: '*' matches an arbitrary, possibly empty,
 * string, '?' matches an arbitrary character.
 * Note that in contrast to glob(), the '/' character can
 * be matched by the wildcards, there are no '[...]' character ranges and '*'
 * and '?' can not be escaped to include them literally
 * in a pattern.
 * When multiple strings must be matched against the same pattern, it is
 * better to compile the pattern to a GPatternSpec using g_pattern_spec_new()
 * and use g_pattern_match_string() instead of g_pattern_match_simple(). This
 * avoids the overhead of repeated pattern compilation.
 */
public class Pattern
{
	
	/** the main Gtk struct */
	protected GPatternSpec* gPatternSpec;
	
	
	public GPatternSpec* getPatternStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GPatternSpec* gPatternSpec);
	
	/**
	 */
	
	/**
	 * Compiles a pattern to a GPatternSpec.
	 * Params:
	 * pattern = a zero-terminated UTF-8 encoded string
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string pattern);
	
	/**
	 * Frees the memory allocated for the GPatternSpec.
	 */
	public void free();
	
	/**
	 * Compares two compiled pattern specs and returns whether they
	 * will match the same set of strings.
	 * Params:
	 * pspec2 = another GPatternSpec
	 * Returns:Whether the compiled patterns are equal
	 */
	public int equal(Pattern pspec2);
	
	/**
	 * Matches a string against a compiled pattern. Passing the correct length of
	 * the string given is mandatory. The reversed string can be omitted by passing
	 * NULL, this is more efficient if the reversed version of the string to be
	 * matched is not at hand, as g_pattern_match() will only construct it if the
	 * compiled pattern requires reverse matches.
	 * Note that, if the user code will (possibly) match a string against a
	 * multitude of patterns containing wildcards, chances are high that some
	 * patterns will require a reversed string. In this case, it's more efficient
	 * to provide the reversed string to avoid multiple constructions thereof in
	 * the various calls to g_pattern_match().
	 * Note also that the reverse of a UTF-8 encoded string can in general
	 * not be obtained by g_strreverse(). This works only
	 * if the string doesn't contain any multibyte characters. GLib offers the
	 * g_utf8_strreverse() function to reverse UTF-8 encoded strings.
	 * Params:
	 * stringLength = the length of string (in bytes, i.e. strlen(),
	 *  not g_utf8_strlen())
	 * string = the UTF-8 encoded string to match
	 * stringReversed = the reverse of string or NULL
	 * Returns:%TRUE if string matches pspec
	 */
	public int match(uint stringLength, string string, string stringReversed);
	
	/**
	 * Matches a string against a compiled pattern. If the string is to be
	 * matched against more than one pattern, consider using g_pattern_match()
	 * instead while supplying the reversed string.
	 * Params:
	 * string = the UTF-8 encoded string to match
	 * Returns:%TRUE if string matches pspec
	 */
	public int matchString(string string);
	
	/**
	 * Matches a string against a pattern given as a string.
	 * If this function is to be called in a loop, it's more efficient to compile
	 * the pattern once with g_pattern_spec_new() and call g_pattern_match_string()
	 * repeatedly.
	 * Params:
	 * pattern = the UTF-8 encoded pattern
	 * string = the UTF-8 encoded string to match
	 * Returns:%TRUE if string matches pspec
	 */
	public static int matchSimple(string pattern, string string);
}
