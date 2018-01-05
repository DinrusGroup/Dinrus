module gtkD.gtk.Version;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtkc.Loader;
private import gtkD.gtkc.paths;




/**
 * Description
 * GTK+ provides version information, primarily useful in configure checks
 * for builds that have a configure script. Applications will not
 * typically use the features described here.
 */
public class Version
{
	
	/*
	 * The major version number of the GTK+ library. (e.g. in GTK+ version 2.12.4 this is 2.)
	 * This variable is in the library, so represents the GTK+ library you have linked against.
	 */
	public static int major();
	
	/*
	 * The minor version number of the GTK+ library. (e.g. in GTK+ version 2.12.4 this is 12.)
	 * This variable is in the library, so represents the GTK+ library you have linked against.
	 */
	public static int minor();
	
	/*
	 * The micro version number of the GTK+ library. (e.g. in GTK+ version 2.12.4 this is 4.)
	 * This variable is in the library, so represents the GTK+ library you have linked against.
	 */
	public static int micro();
	
	/**
	 */
	
	/**
	 * Checks that the GTK+ library in use is compatible with the
	 * given version. Generally you would pass in the constants
	 * GTK_MAJOR_VERSION, GTK_MINOR_VERSION, GTK_MICRO_VERSION
	 * as the three arguments to this function; that produces
	 * a check that the library in use is compatible with
	 * the version of GTK+ the application or module was compiled
	 * against.
	 * Compatibility is defined by two things: first the version
	 * of the running library is newer than the version
	 * required_major.required_minor.required_micro. Second
	 * the running library must be binary compatible with the
	 * version required_major.required_minor.required_micro
	 * (same major version.)
	 * This function is primarily for GTK+ modules; the module
	 * can call this function to check that it wasn't loaded
	 * into an incompatible version of GTK+. However, such a
	 * a check isn't completely reliable, since the module may be
	 * linked against an old version of GTK+ and calling the
	 * old version of gtk_check_version(), but still get loaded
	 * into an application using a newer version of GTK+.
	 * Params:
	 * requiredMajor =  the required major version.
	 * requiredMinor =  the required minor version.
	 * requiredMicro =  the required micro version.
	 * Returns: NULL if the GTK+ library is compatible with the given version, or a string describing the version mismatch. The returned string is owned by GTK+ and should not be modified or freed.
	 */
	public static string checkVersion(uint requiredMajor, uint requiredMinor, uint requiredMicro);
}
