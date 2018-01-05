module gtkD.gtk.VolumeButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.ScaleButton;

/**
 * Description
 * GtkVolumeButton is a subclass of GtkScaleButton that has
 * been tailored for use as a volume control widget with suitable
 * icons, tooltips and accessible labels.
 */
public class VolumeButton : ScaleButton
{
	
	/** the main Gtk struct */
	protected GtkVolumeButton* gtkVolumeButton;
	
	
	public GtkVolumeButton* getVolumeButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkVolumeButton* gtkVolumeButton);
	
	/**
	 */
	
	/**
	 * Creates a GtkVolumeButton, with a range between 0.0 and 1.0, with
	 * a stepping of 0.02. Volume values can be obtained and modified using
	 * the functions from GtkScaleButton.
	 * Since 2.12
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
