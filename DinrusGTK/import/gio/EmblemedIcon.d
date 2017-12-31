module gtkD.gio.EmblemedIcon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.ListG;
private import gtkD.gio.Emblem;
private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gio.IconT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GEmblemedIcon is an implementation of GIcon that supports
 * adding an emblem to an icon. Adding multiple emblems to an
 * icon is ensured via g_emblemed_icon_add_emblem().
 * Note that GEmblemedIcon allows no control over the position
 * of the emblems. See also GEmblem for more information.
 */
public class EmblemedIcon : ObjectG, IconIF
{
	
	/** the main Gtk struct */
	protected GEmblemedIcon* gEmblemedIcon;
	
	
	public GEmblemedIcon* getEmblemedIconStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GEmblemedIcon* gEmblemedIcon);
	
	// add the Icon capabilities
	mixin IconT!(GEmblemedIcon);
	
	/**
	 */
	
	/**
	 * Creates a new emblemed icon for icon with the emblem emblem.
	 * Since 2.18
	 * Params:
	 * icon =  a GIcon
	 * emblem =  a GEmblem
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconIF icon, Emblem emblem);
	
	/**
	 * Gets the main icon for emblemed.
	 * Since 2.18
	 * Returns: a GIcon that is owned by emblemed
	 */
	public IconIF getIcon();
	
	/**
	 * Gets the list of emblems for the icon.
	 * Since 2.18
	 * Returns: a GList of GEmblem s that is owned by emblemed
	 */
	public ListG getEmblems();
	
	/**
	 * Adds emblem to the GList of GEmblem s.
	 * Since 2.18
	 * Params:
	 * emblem =  a GEmblem
	 */
	public void addEmblem(Emblem emblem);
}
