module gtkD.gtk.CheckButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Button;



private import gtkD.gtk.ToggleButton;

/**
 * Description
 * A GtkCheckButton places a discrete GtkToggleButton next to a widget, (usually a GtkLabel). See the section on GtkToggleButton widgets for more information about toggle/check buttons.
 * The important signal ('toggled') is also inherited from GtkToggleButton.
 */
public class CheckButton : ToggleButton
{
	
	/** the main Gtk struct */
	protected GtkCheckButton* gtkCheckButton;
	
	
	public GtkCheckButton* getCheckButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkCheckButton* gtkCheckButton);
	
	/**
	 * Creates a new GtkCheckButton with a GtkLabel to the right of it.
	 * If mnemonic is true the label
	 * will be created using gtk_label_new_with_mnemonic(), so underscores
	 * in label indicate the mnemonic for the check button.
	 * Params:
	 *  label = The text of the button, with an underscore in front of the
	 *  mnemonic character
	 *  mnemonic = true if the button has an mnemnonic
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true);
	
	/** */
	public this(string label, void delegate(CheckButton) onClicked, bool mnemonic=true);
	
	
	/**
	 */
	
	/**
	 * Creates a new GtkCheckButton.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
}
