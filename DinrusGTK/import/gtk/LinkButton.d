module gtkD.gtk.LinkButton;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Button;

/**
 * Description
 * A GtkLinkButton is a GtkButton with a hyperlink, similar to the one
 * used by web browsers, which triggers an action when clicked. It is useful
 * to show quick links to resources.
 * A link button is created by calling either gtk_link_button_new() or
 * gtk_link_button_new_with_label(). If using the former, the URI you pass
 * to the constructor is used as a label for the widget.
 * The URI bound to a GtkLinkButton can be set specifically using
 * gtk_link_button_set_uri(), and retrieved using gtk_link_button_get_uri().
 * GtkLinkButton offers a global hook, which is called when the used clicks
 * on it: see gtk_link_button_set_uri_hook().
 * GtkLinkButton was added in GTK+ 2.10.
 */
public class LinkButton : Button
{
	
	/** the main Gtk struct */
	protected GtkLinkButton* gtkLinkButton;
	
	
	public GtkLinkButton* getLinkButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkLinkButton* gtkLinkButton);
	
	/**
	 */
	
	/**
	 * Creates a new GtkLinkButton with the URI as its text.
	 * Since 2.10
	 * Params:
	 * uri =  a valid URI
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string uri);
	
	/**
	 * Creates a new GtkLinkButton containing a label.
	 * Since 2.10
	 * Params:
	 * uri =  a valid URI
	 * label =  the text of the button
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string uri, string label);
	
	/**
	 * Retrieves the URI set using gtk_link_button_set_uri().
	 * Since 2.10
	 * Returns: a valid URI. The returned string is owned by the link button and should not be modified or freed.
	 */
	public string getUri();
	
	/**
	 * Sets uri as the URI where the GtkLinkButton points. As a side-effect
	 * this unsets the 'visited' state of the button.
	 * Since 2.10
	 * Params:
	 * uri =  a valid URI
	 */
	public void setUri(string uri);
	
	/**
	 * Sets func as the function that should be invoked every time a user clicks
	 * a GtkLinkButton. This function is called before every callback registered
	 * for the "clicked" signal.
	 * If no uri hook has been set, GTK+ defaults to calling gtk_show_uri().
	 * Since 2.10
	 * Params:
	 * func =  a function called each time a GtkLinkButton is clicked, or NULL
	 * data =  user data to be passed to func, or NULL
	 * destroy =  a GDestroyNotify that gets called when data is no longer needed, or NULL
	 * Returns: the previously set hook function.
	 */
	public static GtkLinkButtonUriFunc setUriHook(GtkLinkButtonUriFunc func, void* data, GDestroyNotify destroy);
	
	/**
	 * Retrieves the 'visited' state of the URI where the GtkLinkButton
	 * points. The button becomes visited when it is clicked. If the URI
	 * is changed on the button, the 'visited' state is unset again.
	 * The state may also be changed using gtk_link_button_set_visited().
	 * Since 2.14
	 * Returns: TRUE if the link has been visited, FALSE otherwise
	 */
	public int getVisited();
	
	/**
	 * Sets the 'visited' state of the URI where the GtkLinkButton
	 * points. See gtk_link_button_get_visited() for more details.
	 * Since 2.14
	 * Params:
	 * visited =  the new 'visited' state
	 */
	public void setVisited(int visited);
}
