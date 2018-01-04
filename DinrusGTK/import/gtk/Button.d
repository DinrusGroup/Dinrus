module gtkD.gtk.Button;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Image;
private import gtkD.gtk.ActivatableT;
private import gtkD.gtk.ActivatableIF;



private import gtkD.gtk.Bin;

/**
 * Description
 * The GtkButton widget is generally used to attach a function to that
 * is called when the button is pressed. The various signals and how to use
 * them are outlined below.
 * The GtkButton widget can hold any valid child widget. That is it can
 * hold most any other standard GtkWidget. The most commonly used child is
 * the GtkLabel.
 */
public class Button : Bin, ActivatableIF
{
	
	/** the main Gtk struct */
	protected GtkButton* gtkButton;
	
	
	public GtkButton* getButtonStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkButton* gtkButton);
	
	private static IconSize currentIconSize = IconSize.BUTTON;
	
	/** An arbitrary string to be used by the application */
	private string action;
	
	// add the Activatable capabilities
	mixin ActivatableT!(GtkButton);
	
	/** */
	public static void setIconSize(IconSize iconSize);
	
	/** */
	public static IconSize getIconSize();

	/** */
	public void setActionName(string action);
	
	/** */
	public string getActionName();
	
	/**
	 * Creates a new GtkButton containing a label.
	 * If characters in label are preceded by an underscore, they are underlined.
	 * If you need a literal underscore character in a label, use '__' (two
	 * underscores). The first underlined character represents a keyboard
	 * accelerator called a mnemonic.
	 * Pressing Alt and that key activates the button.
	 * Params:
	 *  label = The text of the button, with an underscore in front of the
	 *  mnemonic character
	 *  mnemonic = true if the button has an mnemnonic
	 * Returns:
	 *  a new GtkButton
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string label, bool mnemonic=true);
	
	/**
	 * Creates a new GtkButton containing the image and text from a stock item.
	 * Some stock ids have preprocessor macros like GTK_STOCK_OK and
	 * GTK_STOCK_APPLY.
	 * If stock_id is unknown, then it will be treated as a mnemonic
	 * label (as for gtk_button_new_with_mnemonic()).
	 * Params:
	 *  StockID = the name of the stock item
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (StockID stockID, bool hideLabel=false);
	
	/** */
	public this(StockID stockID, void delegate(Button) dlg, bool hideLabel=false);
	
	/** */
	public this(string label, void delegate(Button) dlg, bool mnemonic=true);
	
	/** */
	public this(string label, void delegate(Button) dlg, string action);
	
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Button)[] onActivateListeners;
	/**
	 * The ::activate signal on GtkButton is an action signal and
	 * emitting it causes the button to animate press then release.
	 * Applications should never connect to this signal, but use the
	 * "clicked" signal.
	 */
	void addOnActivate(void delegate(Button) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackActivate(GtkButton* widgetStruct, Button button);
	
	void delegate(Button)[] onClickedListeners;
	/**
	 * Emitted when the button has been activated (pressed and released).
	 */
	void addOnClicked(void delegate(Button) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackClicked(GtkButton* buttonStruct, Button button);
	
	void delegate(Button)[] onEnterListeners;
	/**
	 * Emitted when the pointer enters the button.
	 */
	void addOnEnter(void delegate(Button) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackEnter(GtkButton* buttonStruct, Button button);
	
	void delegate(Button)[] onLeaveListeners;
	/**
	 * Emitted when the pointer leaves the button.
	 */
	void addOnLeave(void delegate(Button) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackLeave(GtkButton* buttonStruct, Button button);
	
	void delegate(Button)[] onPressedListeners;
	/**
	 * Emitted when the button is pressed.
	 */
	void addOnPressed(void delegate(Button) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackPressed(GtkButton* buttonStruct, Button button);
	
	void delegate(Button)[] onReleasedListeners;
	/**
	 * Emitted when the button is released.
	 */
	void addOnReleased(void delegate(Button) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackReleased(GtkButton* buttonStruct, Button button);
	
	
	/**
	 * Creates a new GtkButton widget. To add a child widget to the button,
	 * use gtk_container_add().
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Emits a "pressed" signal to the given GtkButton.
	 */
	public void pressed();
	
	/**
	 * Emits a "released" signal to the given GtkButton.
	 */
	public void released();
	
	/**
	 * Emits a "clicked" signal to the given GtkButton.
	 */
	public void clicked();
	
	/**
	 * Emits a "enter" signal to the given GtkButton.
	 */
	public void enter();
	
	/**
	 * Emits a "leave" signal to the given GtkButton.
	 */
	public void leave();
	
	/**
	 * Sets the relief style of the edges of the given GtkButton widget.
	 * Three styles exist, GTK_RELIEF_NORMAL, GTK_RELIEF_HALF, GTK_RELIEF_NONE.
	 * The default style is, as one can guess, GTK_RELIEF_NORMAL.
	 * Params:
	 * newstyle = The GtkReliefStyle as described above.
	 */
	public void setRelief(GtkReliefStyle newstyle);
	
	/**
	 * Returns the current relief style of the given GtkButton.
	 * Returns:The current GtkReliefStyle
	 */
	public GtkReliefStyle getRelief();
	
	/**
	 * Fetches the text from the label of the button, as set by
	 * gtk_button_set_label(). If the label text has not
	 * been set the return value will be NULL. This will be the
	 * case if you create an empty button with gtk_button_new() to
	 * use as a container.
	 * Returns: The text of the label widget. This string is ownedby the widget and must not be modified or freed.
	 */
	public string getLabel();
	
	/**
	 * Sets the text of the label of the button to str. This text is
	 * also used to select the stock item if gtk_button_set_use_stock()
	 * is used.
	 * This will also clear any previously set labels.
	 * Params:
	 * label =  a string
	 */
	public void setLabel(string label);
	
	/**
	 * Returns whether the button label is a stock item.
	 * Returns: TRUE if the button label is used to select a stock item instead of being used directly as the label text.
	 */
	public int getUseStock();
	
	/**
	 * If TRUE, the label set on the button is used as a
	 * stock id to select the stock item for the button.
	 * Params:
	 * useStock =  TRUE if the button should use a stock item
	 */
	public void setUseStock(int useStock);
	
	/**
	 * Returns whether an embedded underline in the button label indicates a
	 * mnemonic. See gtk_button_set_use_underline().
	 * Returns: TRUE if an embedded underline in the button label indicates the mnemonic accelerator keys.
	 */
	public int getUseUnderline();
	
	/**
	 * If true, an underline in the text of the button label indicates
	 * the next character should be used for the mnemonic accelerator key.
	 * Params:
	 * useUnderline =  TRUE if underlines in the text indicate mnemonics
	 */
	public void setUseUnderline(int useUnderline);
	
	/**
	 * Sets whether the button will grab focus when it is clicked with the mouse.
	 * Making mouse clicks not grab focus is useful in places like toolbars where
	 * you don't want the keyboard focus removed from the main area of the
	 * application.
	 * Since 2.4
	 * Params:
	 * focusOnClick =  whether the button grabs focus when clicked with the mouse
	 */
	public void setFocusOnClick(int focusOnClick);
	
	/**
	 * Returns whether the button grabs focus when it is clicked with the mouse.
	 * See gtk_button_set_focus_on_click().
	 * Since 2.4
	 * Returns: TRUE if the button grabs focus when it is clicked with the mouse.
	 */
	public int getFocusOnClick();
	
	/**
	 * Sets the alignment of the child. This property has no effect unless
	 * the child is a GtkMisc or a GtkAligment.
	 * Since 2.4
	 * Params:
	 * xalign =  the horizontal position of the child, 0.0 is left aligned,
	 *  1.0 is right aligned
	 * yalign =  the vertical position of the child, 0.0 is top aligned,
	 *  1.0 is bottom aligned
	 */
	public void setAlignment(float xalign, float yalign);
	
	/**
	 * Gets the alignment of the child in the button.
	 * Since 2.4
	 * Params:
	 * xalign =  return location for horizontal alignment
	 * yalign =  return location for vertical alignment
	 */
	public void getAlignment(out float xalign, out float yalign);
	
	/**
	 * Set the image of button to the given widget. Note that
	 * it depends on the "gtk-button-images" setting whether the
	 * image will be displayed or not, you don't have to call
	 * gtk_widget_show() on image yourself.
	 * Since 2.6
	 * Params:
	 * image =  a widget to set as the image for the button
	 */
	public void setImage(Widget image);
	
	/**
	 * Gets the widget that is currenty set as the image of button.
	 * This may have been explicitly set by gtk_button_set_image()
	 * or constructed by gtk_button_new_from_stock().
	 * Since 2.6
	 * Returns: a GtkWidget or NULL in case there is no image
	 */
	public Widget getImage();
	
	/**
	 * Sets the position of the image relative to the text
	 * inside the button.
	 * Since 2.10
	 * Params:
	 * position =  the position
	 */
	public void setImagePosition(GtkPositionType position);
	
	/**
	 * Gets the position of the image relative to the text
	 * inside the button.
	 * Since 2.10
	 * Returns: the position
	 */
	public GtkPositionType getImagePosition();
}
