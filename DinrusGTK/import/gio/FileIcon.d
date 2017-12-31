module gtkD.gio.FileIcon;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.IconT;
private import gtkD.gio.IconIF;
private import gtkD.gio.LoadableIconT;
private import gtkD.gio.LoadableIconIF;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GFileIcon specifies an icon by pointing to an image file
 * to be used as icon.
 */
public class FileIcon : ObjectG, IconIF, LoadableIconIF
{
	
	/** the main Gtk struct */
	protected GFileIcon* gFileIcon;
	
	
	public GFileIcon* getFileIconStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GFileIcon* gFileIcon);
	
	// add the Icon capabilities
	mixin IconT!(GFileIcon);
	
	// add the LoadableIcon capabilities
	mixin LoadableIconT!(GFileIcon);
	
	/**
	 */
	
	/**
	 * Creates a new icon for a file.
	 * Params:
	 * file =  a GFile.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (GFile* file);
	
	/**
	 * Gets the GFile associated with the given icon.
	 * Returns: a GFile, or NULL.
	 */
	public GFile* getFile();
}
