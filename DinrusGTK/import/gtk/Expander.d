module gtkD.gtk.Expander;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;



private import gtkD.gtk.Bin;

/**
 * Description
 * A GtkExpander allows the user to hide or show its child by clicking
 * on an expander triangle similar to the triangles used in a GtkTreeView.
 * Normally you use an expander as you would use any other descendant
 * of GtkBin; you create the child widget and use gtk_container_add()
 * to add it to the expander. When the expander is toggled, it will take
 * care of showing and hiding the child automatically.
 * Special Usage
 * There are situations in which you may prefer to show and hide the
 * expanded widget yourself, such as when you want to actually create
 * the widget at expansion time. In this case, create a GtkExpander
 * but do not add a child to it. The expander widget has an
 * expanded property which can be used to monitor
 * its expansion state. You should watch this property with a signal
 * connection as follows:
 * expander = gtk_expander_new_with_mnemonic ("_More Options");
 * g_signal_connect (expander, "notify::expanded",
 *  G_CALLBACK (expander_callback), NULL);
 * ...
 * static void
 * expander_callback (GObject *object,
 *  GParamSpec *param_spec,
 *  gpointer user_data)
 * {
	 *  GtkExpander *expander;
	 *  expander = GTK_EXPANDER (object);
	 *  if (gtk_expander_get_expanded (expander))
	 *  {
		 *  /+* Show or create widgets +/
	 *  }
	 *  else
	 *  {
		 *  /+* Hide or destroy widgets +/
	 *  }
 * }
 * GtkExpander as GtkBuildable
 * The GtkExpander implementation of the GtkBuildable interface
 * supports placing a child in the label position by specifying
 * "label" as the "type" attribute of a <child> element.
 * A normal content child can be specified without specifying
 * a <child> type attribute.
 * Example 44. A UI definition fragment with GtkExpander
 * <object class="GtkExpander">
 *  <child type="label">
 *  <object class="GtkLabel" id="expander-label"/>
 *  </child>
 *  <child>
 *  <object class="GtkEntry" id="expander-content"/>
 *  </child>
 * </object>
 */
public class Expander : Bin
{
	
	/** the main Gtk struct */
	protected GtkExpander* gtkExpander;
	
	
	public GtkExpander* getExpanderStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkExpander* gtkExpander);
	
	/**
	 * Creates a new expander using label as the text of the label.
	 * Since 2.4
	 * Params:
	 *  label = the text of the label
	 *  mnemonic = if true characters in label that are preceded by an underscore,
	 *  are underlined.
	 *  If you need a literal underscore character in a label, use '__' (two
	 *  underscores). The first underlined character represents a keyboard
	 *  accelerator called a mnemonic.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true);

	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Expander)[] onActivateListeners;
	/**
	 */
	void addOnActivate(void delegate(Expander) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActivate(GtkExpander* expanderStruct, Expander expander);
	
	
	/**
	 * Sets the state of the expander. Set to TRUE, if you want
	 * the child widget to be revealed, and FALSE if you want the
	 * child widget to be hidden.
	 * Since 2.4
	 * Params:
	 * expanded =  whether the child widget is revealed
	 */
	public void setExpanded(int expanded);
	
	/**
	 * Queries a GtkExpander and returns its current state. Returns TRUE
	 * if the child widget is revealed.
	 * See gtk_expander_set_expanded().
	 * Since 2.4
	 * Returns: the current state of the expander.
	 */
	public int getExpanded();
	
	/**
	 * Sets the spacing field of expander, which is the number of pixels to
	 * place between expander and the child.
	 * Since 2.4
	 * Params:
	 * spacing =  distance between the expander and child in pixels.
	 */
	public void setSpacing(int spacing);
	
	/**
	 * Gets the value set by gtk_expander_set_spacing().
	 * Since 2.4
	 * Returns: spacing between the expander and child.
	 */
	public int getSpacing();
	
	/**
	 * Sets the text of the label of the expander to label.
	 * This will also clear any previously set labels.
	 * Since 2.4
	 * Params:
	 * label =  a string
	 */
	public void setLabel(string label);
	
	/**
	 * Fetches the text from a label widget including any embedded
	 * underlines indicating mnemonics and Pango markup, as set by
	 * gtk_expander_set_label(). If the label text has not been set the
	 * return value will be NULL. This will be the case if you create an
	 * empty button with gtk_button_new() to use as a container.
	 * Note that this function behaved differently in versions prior to
	 * 2.14 and used to return the label text stripped of embedded
	 * underlines indicating mnemonics and Pango markup. This problem can
	 * be avoided by fetching the label text directly from the label
	 * widget.
	 * Since 2.4
	 * Returns: The text of the label widget. This string is ownedby the widget and must not be modified or freed.
	 */
	public string getLabel();
	
	/**
	 * If true, an underline in the text of the expander label indicates
	 * the next character should be used for the mnemonic accelerator key.
	 * Since 2.4
	 * Params:
	 * useUnderline =  TRUE if underlines in the text indicate mnemonics
	 */
	public void setUseUnderline(int useUnderline);
	
	/**
	 * Returns whether an embedded underline in the expander label indicates a
	 * mnemonic. See gtk_expander_set_use_underline().
	 * Since 2.4
	 * Returns: TRUE if an embedded underline in the expander label indicates the mnemonic accelerator keys.
	 */
	public int getUseUnderline();
	
	/**
	 * Sets whether the text of the label contains markup in Pango's text markup
	 * language. See gtk_label_set_markup().
	 * Since 2.4
	 * Params:
	 * useMarkup =  TRUE if the label's text should be parsed for markup
	 */
	public void setUseMarkup(int useMarkup);
	
	/**
	 * Returns whether the label's text is interpreted as marked up with
	 * the Pango text markup
	 * language. See gtk_expander_set_use_markup().
	 * Since 2.4
	 * Returns: TRUE if the label's text will be parsed for markup
	 */
	public int getUseMarkup();
	
	/**
	 * Set the label widget for the expander. This is the widget
	 * that will appear embedded alongside the expander arrow.
	 * Since 2.4
	 * Params:
	 * labelWidget =  the new label widget
	 */
	public void setLabelWidget(Widget labelWidget);
	
	/**
	 * Retrieves the label widget for the frame. See
	 * gtk_expander_set_label_widget().
	 * Since 2.4
	 * Returns: the label widget, or NULL if there is none.
	 */
	public Widget getLabelWidget();
}
