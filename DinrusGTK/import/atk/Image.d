
module gtkD.atk.Image;

public  import gtkD.gtkc.atktypes;

private import gtkD.gtkc.atk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;




/**
 * Description
 * AtkImage should be implemented by AtkObject subtypes on behalf of
 * components which display image/pixmap information onscreen, and which
 * provide information (other than just widget borders, etc.) via that
 * image content. For instance, icons, buttons with icons, toolbar
 * elements, and image viewing panes typically should implement AtkImage.
 * AtkImage primarily provides two types of information: coordinate
 * information (useful for screen review mode of screenreaders, and for use
 * by onscreen magnifiers), and descriptive information. The descriptive
 * information is provided for alternative, text-only presentation of the
 * most significant information present in the image.
 */
public class Image
{
	
	/** the main Gtk struct */
	protected AtkImage* atkImage;
	
	
	public AtkImage* getImageStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (AtkImage* atkImage);
	
	/**
	 */
	
	/**
	 * Gets the position of the image in the form of a point specifying the
	 * images top-left corner.
	 * Params:
	 * x =  address of gint to put x coordinate position; otherwise, -1 if value cannot be obtained.
	 * y =  address of gint to put y coordinate position; otherwise, -1 if value cannot be obtained.
	 * coordType =  specifies whether the coordinates are relative to the screen
	 * or to the components top level window
	 */
	public void getImagePosition(out int x, out int y, AtkCoordType coordType);
	
	/**
	 * Get a textual description of this image.
	 * Returns: a string representing the image description
	 */
	public string getImageDescription();
	
	/**
	 * Sets the textual description for this image.
	 * Params:
	 * description =  a string description to set for image
	 * Returns: boolean TRUE, or FALSE if operation couldnot be completed.
	 */
	public int setImageDescription(string description);
	
	/**
	 * Get the width and height in pixels for the specified image.
	 * The values of width and height are returned as -1 if the
	 * values cannot be obtained (for instance, if the object is not onscreen).
	 * Params:
	 * width =  filled with the image width, or -1 if the value cannot be obtained.
	 * height =  filled with the image height, or -1 if the value cannot be obtained.
	 */
	public void getImageSize(out int width, out int height);
	
	/**
	 * Since ATK 1.12
	 * Returns:a string corresponding to the POSIX LC_MESSAGES locale used by the image description, or NULL if the image does not specify a locale.
	 */
	public string getImageLocale();
}
