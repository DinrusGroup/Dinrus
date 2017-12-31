module gtkD.atk.Document;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;




/**
 * Description
 * The AtkDocument interface should be supported by any object whose content is a
 * representation or view of a document. The AtkDocument interface should appear
 * on the toplevel container for the document content; however AtkDocument
 * instances may be nested (i.e. an AtkDocument may be a descendant of another
 * AtkDocument) in those cases where one document contains "embedded content"
 * which can reasonably be considered a document in its own right.
 */
public class Document
{
	
	/** the main Gtk struct */
	protected AtkDocument* atkDocument;
	
	
	public AtkDocument* getDocumentStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkDocument* atkDocument);
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(Document)[] onLoadCompleteListeners;
	/**
	 * The 'load-complete' signal is emitted when a pending load of a static
	 * document has completed. This signal is to be expected by ATK clients
	 * if and when AtkDocument implementors expose ATK_STATE_BUSY. If the state
	 * of an AtkObject which implements AtkDocument does not include ATK_STATE_BUSY,
	 * it should be safe for clients to assume that the AtkDocument's static contents
	 * are fully loaded into the container. (Dynamic document contents should
	 * be exposed via other signals.)
	 */
	void addOnLoadComplete(void delegate(Document) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackLoadComplete(AtkDocument* atkdocumentStruct, Document document);
	
	void delegate(Document)[] onLoadStoppedListeners;
	/**
	 * The 'load-stopped' signal is emitted when a pending load of document contents
	 * is cancelled, paused, or otherwise interrupted by the user or application
	 * logic. It should not however be
	 * emitted while waiting for a resource (for instance while blocking on a file or
	 * network read) unless a user-significant timeout has occurred.
	 */
	void addOnLoadStopped(void delegate(Document) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackLoadStopped(AtkDocument* atkdocumentStruct, Document document);
	
	void delegate(Document)[] onReloadListeners;
	/**
	 * The 'reload' signal is emitted when the contents of a document is refreshed
	 * from its source. Once 'reload' has been emitted, a matching 'load-complete'
	 * or 'load-stopped' signal should follow, which clients may await before
	 * interrogating ATK for the latest document content.
	 */
	void addOnReload(void delegate(Document) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	extern(C) static void callBackReload(AtkDocument* atkdocumentStruct, Document document);
	
	
	/**
	 * Gets a string indicating the document type.
	 * Returns: a string indicating the document type
	 */
	public string getDocumentType();
	
	/**
	 * Gets a gpointer that points to an instance of the DOM. It is
	 * up to the caller to check atk_document_get_type to determine
	 * how to cast this pointer.
	 * Returns: a gpointer that points to an instance of the DOM.
	 */
	public void* getDocument();
	
	/**
	 * Since 1.12
	 * Params:
	 * attributeName =  a character string representing the name of the attribute
	 *  whose value is being queried.
	 * Returns: a string value associated with the named attribute for this document, or NULL if a value for attribute_name has not been specified for this document.
	 */
	public string getAttributeValue(string attributeName);
	
	/**
	 * Since 1.12
	 * Params:
	 * attributeName =  a character string representing the name of the attribute
	 *  whose value is being set.
	 * attributeValue =  a string value to be associated with attribute_name.
	 * Returns: TRUE if value is successfully associated with attribute_name for this document, FALSE otherwise (e.g. if the document does not allow the attribute to be modified).
	 */
	public int setAttributeValue(string attributeName, string attributeValue);
	
	/**
	 * Gets an AtkAttributeSet which describes document-wide
	 *  attributes as name-value pairs.
	 * Since 1.12
	 * Returns: An AtkAttributeSet containing the explicitly set name-value-pair attributes associated with this document as a whole.
	 */
	public AtkAttributeSet* getAttributes();
	
	/**
	 * Gets a UTF-8 string indicating the POSIX-style LC_MESSAGES locale
	 *  of the content of this document instance. Individual
	 *  text substrings or images within this document may have
	 *  a different locale, see atk_text_get_attributes and
	 *  atk_image_get_image_locale.
	 * Returns: a UTF-8 string indicating the POSIX-style LC_MESSAGES locale of the document content as a whole, or NULL if the document content does not specify a locale.Signal DetailsThe "load-complete" signalvoid user_function (AtkDocument *atkdocument, gpointer user_data) : Run LastThe 'load-complete' signal is emitted when a pending load of a staticdocument has completed. This signal is to be expected by ATK clientsif and when AtkDocument implementors expose ATK_STATE_BUSY. If the stateof an AtkObject which implements AtkDocument does not include ATK_STATE_BUSY,it should be safe for clients to assume that the AtkDocument's static contentsare fully loaded into the container. (Dynamic document contents shouldbe exposed via other signals.)
	 */
	public string getLocale();
}
