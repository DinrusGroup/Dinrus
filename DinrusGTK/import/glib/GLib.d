module gtkD.glib.GLib;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * GLib provides version information, primarily useful in configure checks
 * for builds that have a configure script. Applications will not
 * typically use the features described here.
 */
public class Version
{
	
	/**
	 */
	
	/**
	 * Checks that the GLib library in use is compatible with the
	 * given version. Generally you would pass in the constants
	 * GLIB_MAJOR_VERSION, GLIB_MINOR_VERSION, GLIB_MICRO_VERSION
	 * as the three arguments to this function; that produces
	 * a check that the library in use is compatible with
	 * the version of GLib the application or module was compiled
	 * against.
	 * Compatibility is defined by two things: first the version
	 * of the running library is newer than the version
	 * required_major.required_minor.required_micro. Second
	 * the running library must be binary compatible with the
	 * version required_major.required_minor.required_micro
	 * (same major version.)
	 * Since 2.6
	 * Params:
	 * requiredMajor =  the required major version.
	 * requiredMinor =  the required minor version.
	 * requiredMicro =  the required micro version.
	 * Returns: NULL if the GLib library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by GLib and must not be modified or freed.
	 */
	public static string checkVersion(uint requiredMajor, uint requiredMinor, uint requiredMicro);
}
