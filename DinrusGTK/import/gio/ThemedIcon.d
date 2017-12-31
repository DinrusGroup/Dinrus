module gtkD.gio.ThemedIcon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gio.IconT;
private import gtkD.gio.IconIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GThemedIcon is an implementation of GIcon that supports icon themes.
 * GThemedIcon contains a list of all of the icons present in an icon
 * theme, so that icons can be looked up quickly. GThemedIcon does
 * not provide actual pixmaps for icons, just the icon names.
 * Ideally something like gtk_icon_theme_choose_icon() should be used to
 * resolve the list of names so that fallback icons work nicely with
 * themes that inherit other themes.
 */
public class ThemedIcon : ObjectG, IconIF
{
	
	/** the main Gtk struct */
	protected GThemedIcon* gThemedIcon;
	
	
	public GThemedIcon* getThemedIconStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GThemedIcon* gThemedIcon);
	
	// add the Icon capabilities
	mixin IconT!(GThemedIcon);
	
	/**
	 */
	
	/**
	 * Creates a new themed icon for iconnames.
	 * Params:
	 * iconnames =  an array of strings containing icon names.
	 * len =  the length of the iconnames array, or -1 if iconnames is
	 *  NULL-terminated
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string[] iconnames, int len);
	
	/**
	 * Creates a new themed icon for iconname, and all the names
	 * that can be created by shortening iconname at '-' characters.
	 * Params:
	 * iconname =  a string containing an icon name
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string iconname);
	
	/**
	 * Prepend a name to the list of icons from within icon.
	 * Note
	 * Note that doing so invalidates the hash computed by prior calls
	 * to g_icon_hash().
	 * Since 2.18
	 * Params:
	 * icon =  a GThemedIcon
	 * iconname =  name of icon to prepend to list of icons from within icon.
	 */
	public void prependName(string iconname);
	
	/**
	 * Append a name to the list of icons from within icon.
	 * Note
	 * Note that doing so invalidates the hash computed by prior calls
	 * to g_icon_hash().
	 * Params:
	 * icon =  a GThemedIcon
	 * iconname =  name of icon to append to list of icons from within icon.
	 */
	public void appendName(string iconname);
	
	/**
	 * Gets the names of icons from within icon.
	 * Returns: a list of icon names.
	 */
	public string[] getNames();
}
