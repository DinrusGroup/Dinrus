module gtkD.atk.Hyperlink;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.ObjectAtk;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * An ATK object which encapsulates a link or set of links
 * (for instance in the case of client-side image maps) in a hypertext document.
 * It may implement the AtkAction interface. AtkHyperlink may also be used
 * to refer to inline embedded content, since it allows specification of a start
 * and end offset within the host AtkHypertext object.
 */
public class Hyperlink : ObjectG
{

	/** the main Gtk struct */
	protected AtkHyperlink* atkHyperlink;


	public AtkHyperlink* getHyperlinkStruct();


	/** the main Gtk struct as a void* */
	protected override void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkHyperlink* atkHyperlink);

	/**
	 */
	int[char[]] connectedSignals;

	void delegate(Hyperlink)[] onLinkActivatedListeners;
	/**
	 * The signal link-activated is emitted when a link is activated.
	 */
	void addOnLinkActivated(void delegate(Hyperlink) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackLinkActivated(AtkHyperlink* atkhyperlinkStruct, Hyperlink hyperlink);



	/**
	 * Get a the URI associated with the anchor specified
	 * by i of link_.
	 * Multiple anchors are primarily used by client-side image maps.
	 * Params:
	 * i =  a (zero-index) integer specifying the desired anchor
	 * Returns: a string specifying the URI
	 */
	public string getUri(int i);

	/**
	 * Returns the item associated with this hyperlinks nth anchor.
	 * For instance, the returned AtkObject will implement AtkText
	 * if link_ is a text hyperlink, AtkImage if link_ is an image
	 * hyperlink etc.
	 * Multiple anchors are primarily used by client-side image maps.
	 * Params:
	 * i =  a (zero-index) integer specifying the desired anchor
	 * Returns: an AtkObject associated with this hyperlinks i-th anchor
	 */
	public ObjectAtk getObject(int i);

	/**
	 * Gets the index with the hypertext document at which this link ends.
	 * Returns: the index with the hypertext document at which this link ends
	 */
	public int getEndIndex();

	/**
	 * Gets the index with the hypertext document at which this link begins.
	 * Returns: the index with the hypertext document at which this link begins
	 */
	public int getStartIndex();

	/**
	 * Since the document that a link is associated with may have changed
	 * this method returns TRUE if the link is still valid (with
	 * respect to the document it references) and FALSE otherwise.
	 * Returns: whether or not this link is still valid
	 */
	public int isValid();

	/**
	 * Indicates whether the link currently displays some or all of its
	 *  content inline. Ordinary HTML links will usually return
	 *  FALSE, but an inline lt;srcgt; HTML element will return
	 *  TRUE.
	 * a *
	 * Returns: whether or not this link displays its content inline.
	 */
	public int isInline();

	/**
	 * Gets the number of anchors associated with this hyperlink.
	 * Returns: the number of anchors associated with this hyperlink
	 */
	public int getNAnchors();

	/**
	 * Warning
	 * atk_hyperlink_is_selected_link is deprecated and should not be used in newly-written code. Please use ATK_STATE_SELECTED to indicate when a hyperlink within a Hypertext container is selected.
	 * Determines whether this AtkHyperlink is selected
	 * Since 1.4
	 * Returns: True is the AtkHyperlink is selected, False otherwise
	 */
	public int isSelectedLink();
}
