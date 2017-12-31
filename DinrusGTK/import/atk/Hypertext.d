module gtkD.atk.Hypertext;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.atk.Hyperlink;




/**
 * Description
 * An interface used for objects which implement linking between multiple
 * resource or content locations, or multiple 'markers' within a single
 * document. A Hypertext instance is associated with one or more Hyperlinks,
 * which are associated with particular offsets within the Hypertext's included
 * content. While this interface is derived from Text, there is no requirement that Hypertext instances have textual content; they may implement Image as well, and Hyperlinks need not have non-zero text offsets.
 */
public class Hypertext
{
	
	/** the main Gtk struct */
	protected AtkHypertext* atkHypertext;
	
	
	public AtkHypertext* getHypertextStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkHypertext* atkHypertext);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(gint, Hypertext)[] onLinkSelectedListeners;
	/**
	 * The "link-selected" signal is emitted by an AtkHyperText object when one of
	 * the hyperlinks associated with the object is selected.
	 * See Also
	 * AtkHyperlink
	 */
	void addOnLinkSelected(void delegate(gint, Hypertext) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackLinkSelected(AtkHypertext* atkhypertextStruct, gint arg1, Hypertext hypertext);
	
	
	/**
	 * Gets the link in this hypertext document at index
	 * link_index
	 * Params:
	 * linkIndex =  an integer specifying the desired link
	 * Returns: the link in this hypertext document atindex link_index
	 */
	public Hyperlink getLink(int linkIndex);
	
	/**
	 * Gets the number of links within this hypertext document.
	 * Returns: the number of links within this hypertext document
	 */
	public int getNLinks();
	
	/**
	 * Gets the index into the array of hyperlinks that is associated with
	 * the character specified by char_index.
	 * Params:
	 * charIndex =  a character index
	 * Returns: an index into the array of hyperlinks in hypertext,or -1 if there is no hyperlink associated with this character.Signal DetailsThe "link-selected" signalvoid user_function (AtkHypertext *atkhypertext, gint arg1, gpointer user_data) : Run LastThe "link-selected" signal is emitted by an AtkHyperText object when one ofthe hyperlinks associated with the object is selected.
	 */
	public int getLinkIndex(int charIndex);
}
