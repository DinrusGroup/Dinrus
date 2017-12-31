
module gtkD.gio.Emblem;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.Icon;
private import gtkD.gio.IconIF;
private import gtkD.gio.IconT;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GEmblem is an implementation of GIcon that supports
 * having an emblem, which is an icon with additional properties.
 * It can than be added to a GEmblemedIcon.
 * Currently, only metainformation about the emblem's origin is
 * supported. More may be added in the future.
 */
public class Emblem : ObjectG, IconIF
{
	
	/** the main Gtk struct */
	protected GEmblem* gEmblem;
	
	
	public GEmblem* getEmblemStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GEmblem* gEmblem);
	
	// add the Icon capabilities
	mixin IconT!(GEmblem);
	
	/**
	 */
	
	/**
	 * Creates a new emblem for icon.
	 * Since 2.18
	 * Params:
	 * icon =  a GIcon containing the icon.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconIF icon);
	
	/**
	 * Creates a new emblem for icon.
	 * Since 2.18
	 * Params:
	 * icon =  a GIcon containing the icon.
	 * origin =  a GEmblemOrigin enum defining the emblem's origin
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (IconIF icon, GEmblemOrigin origin);
	
	/**
	 * Gives back the icon from emblem.
	 * Since 2.18
	 * Returns: a GIcon. The returned object belongs to the emblem and should not be modified or freed.
	 */
	public IconIF getIcon();
	
	/**
	 * Gets the origin of the emblem.
	 * Since 2.18
	 * Returns: the origin of the emblem
	 */
	public GEmblemOrigin getOrigin();
}
