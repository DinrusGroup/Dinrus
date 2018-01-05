module gtkD.pango.PgVersion;

public  import gtkD.gtkc.pangotypes;

private import gtkD.gtkc.pango;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.pango.PgMatrix;




/**
 * Description
 * The capital-letter macros defined here can be used to check the version of
 * Pango at compile-time, and to encode Pango versions into
 * integers.
 * The functions can be used to check the version of the linked Pango library
 * at run-time.
 */
public class PgVersion
{
	
	/**
	 * This is similar to the macro PANGO_VERSION_STRING except that
	 * it returns the version of Pango available at run-time, as opposed to
	 * the version available at compile-time.
	 * Since 1.16
	 * Returns: A string containing the version of Pango library available at run time. The returned string is owned by Pango and should not be modified or freed.
	 */
	public static string strin();
	
	/**
	 */
	
	/**
	 * This is similar to the macro PANGO_VERSION except that
	 * it returns the encoded version of Pango available at run-time,
	 * as opposed to the version available at compile-time.
	 * A version number can be encoded into an integer using
	 * PANGO_VERSION_ENCODE().
	 * Since 1.16
	 * Returns: The encoded version of Pango library available at run time.
	 */
	public static int versio();
	
	/**
	 * Checks that the Pango library in use is compatible with the
	 * given version. Generally you would pass in the constants
	 * PANGO_VERSION_MAJOR, PANGO_VERSION_MINOR, PANGO_VERSION_MICRO
	 * as the three arguments to this function; that produces
	 * a check that the library in use at run-time is compatible with
	 * the version of Pango the application or module was compiled against.
	 * Compatibility is defined by two things: first the version
	 * of the running library is newer than the version
	 * required_major.required_minor.required_micro. Second
	 * the running library must be binary compatible with the
	 * version required_major.required_minor.required_micro
	 * (same major version.)
	 * For compile-time version checking use PANGO_VERSION_CHECK().
	 * Since 1.16
	 * Params:
	 * requiredMajor =  the required major version.
	 * requiredMinor =  the required minor version.
	 * requiredMicro =  the required major version.
	 * Returns: NULL if the Pango library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by Pango and should not be modified or freed.
	 */
	public static string check(int requiredMajor, int requiredMinor, int requiredMicro);
}
