module gtkD.atk.EditableText;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * AtkEditableText should be implemented by UI components which contain
 * text which the user can edit, via the AtkObject corresponding to that
 * component (see AtkObject).
 * AtkEditableText is a subclass of AtkText, and as such, an object which
 * implements AtkEditableText is by definition an AtkText implementor as well.
 */
public class EditableText
{
	
	/** the main Gtk struct */
	protected AtkEditableText* atkEditableText;
	
	
	public AtkEditableText* getEditableTextStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();

	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkEditableText* atkEditableText);
	
	/**
	 */
	
	/**
	 * Sets the attributes for a specified range. See the ATK_ATTRIBUTE
	 * macros (such as ATK_ATTRIBUTE_LEFT_MARGIN) for examples of attributes
	 * that can be set. Note that other attributes that do not have corresponding
	 * ATK_ATTRIBUTE macros may also be set for certain text widgets.
	 * Params:
	 * attribSet =  an AtkAttributeSet
	 * startOffset =  start of range in which to set attributes
	 * endOffset =  end of range in which to set attributes
	 * Returns: TRUE if attributes successfully set for the specifiedrange, otherwise FALSE
	 */
	public int setRunAttributes(AtkAttributeSet* attribSet, int startOffset, int endOffset);
	
	/**
	 * Set text contents of text.
	 * Params:
	 * string =  string to set for text contents of text
	 */
	public void setTextContents(string string);
	
	/**
	 * Insert text at a given position.
	 * Params:
	 * string =  the text to insert
	 * length =  the length of text to insert, in bytes
	 * position =  The caller initializes this to
	 * the position at which to insert the text. After the call it
	 * points at the position after the newly inserted text.
	 */
	public void insertText(string string, int length, inout int position);
	
	/**
	 * Copy text from start_pos up to, but not including end_pos
	 * to the clipboard.
	 * Params:
	 * startPos =  start position
	 * endPos =  end position
	 */
	public void copyText(int startPos, int endPos);
	
	/**
	 * Copy text from start_pos up to, but not including end_pos
	 * to the clipboard and then delete from the widget.
	 * Params:
	 * startPos =  start position
	 * endPos =  end position
	 */
	public void cutText(int startPos, int endPos)
	{
		// void atk_editable_text_cut_text (AtkEditableText *text,  gint start_pos,  gint end_pos);
		atk_editable_text_cut_text(atkEditableText, startPos, endPos);
	}
	
	/**
	 * Delete text start_pos up to, but not including end_pos.
	 * Params:
	 * startPos =  start position
	 * endPos =  end position
	 */
	public void deleteText(int startPos, int endPos);
	
	/**
	 * Paste text from clipboard to specified position.
	 * Params:
	 * position =  position to paste
	 */
	public void pasteText(int position);
}
