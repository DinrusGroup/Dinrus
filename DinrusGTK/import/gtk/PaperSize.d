module gtkD.gtk.PaperSize;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.KeyFile;
private import gtkD.glib.ListG;




/**
 * Description
 * GtkPaperSize handles paper sizes. It uses the standard called
 * "PWG 5101.1-2002 PWG: Standard for Media Standardized Names"
 * to name the paper sizes (and to get the data for the page sizes).
 * In addition to standard paper sizes, GtkPaperSize allows to
 * construct custom paper sizes with arbitrary dimensions.
 * The GtkPaperSize object stores not only the dimensions (width
 * and height) of a paper size and its name, it also provides
 * default print margins.
 * Printing support has been added in GTK+ 2.10.
 */
public class PaperSize
{
	
	/** the main Gtk struct */
	protected GtkPaperSize* gtkPaperSize;
	
	
	public GtkPaperSize* getPaperSizeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPaperSize* gtkPaperSize);
	
	/**
	 */
	
	/**
	 * Creates a new GtkPaperSize object by parsing a
	 * PWG 5101.1-2002
	 * paper name.
	 * If name is NULL, the default paper size is returned,
	 * see gtk_paper_size_get_default().
	 * Since 2.10
	 * Params:
	 * name =  a paper size name, or NULL
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name);
	
	/**
	 * Creates a new GtkPaperSize object by using
	 * PPD information.
	 * If ppd_name is not a recognized PPD paper name,
	 * ppd_display_name, width and height are used to
	 * construct a custom GtkPaperSize object.
	 * Since 2.10
	 * Params:
	 * ppdName =  a PPD paper name
	 * ppdDisplayName =  the corresponding human-readable name
	 * width =  the paper width, in points
	 * height =  the paper height in points
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string ppdName, string ppdDisplayName, double width, double height);
	
	/**
	 * Creates a new GtkPaperSize object with the
	 * given parameters.
	 * Since 2.10
	 * Params:
	 * name =  the paper name
	 * displayName =  the human-readable name
	 * width =  the paper width, in units of unit
	 * height =  the paper height, in units of unit
	 * unit =  the unit for width and height
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name, string displayName, double width, double height, GtkUnit unit);
	
	/**
	 * Copies an existing GtkPaperSize.
	 * Since 2.10
	 * Returns: a copy of other
	 */
	public PaperSize copy();
	
	/**
	 * Free the given GtkPaperSize object.
	 * Since 2.10
	 */
	public void free();
	
	/**
	 * Compares two GtkPaperSize objects.
	 * Since 2.10
	 * Params:
	 * size2 =  another GtkPaperSize object
	 * Returns: TRUE, if size1 and size2 represent the same paper size
	 */
	public int isEqual(PaperSize size2);
	
	/**
	 * Creates a list of known paper sizes.
	 * Since 2.12
	 * Params:
	 * includeCustom =  whether to include custom paper sizes
	 *  as defined in the page setup dialog
	 * Returns: a newly allocated list of newly  allocated GtkPaperSize objects
	 */
	public static ListG getPaperSizes(int includeCustom);
	
	/**
	 * Gets the name of the GtkPaperSize.
	 * Since 2.10
	 * Returns: the name of size
	 */
	public string getName();
	
	/**
	 * Gets the human-readable name of the GtkPaperSize.
	 * Since 2.10
	 * Returns: the human-readable name of size
	 */
	public string getDisplayName();
	
	/**
	 * Gets the PPD name of the GtkPaperSize, which
	 * may be NULL.
	 * Since 2.10
	 * Returns: the PPD name of size
	 */
	public string getPpdName();
	
	/**
	 * Gets the paper width of the GtkPaperSize, in
	 * units of unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the paper width
	 */
	public double getWidth(GtkUnit unit);
	
	/**
	 * Gets the paper height of the GtkPaperSize, in
	 * units of unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the paper height
	 */
	public double getHeight(GtkUnit unit);
	
	/**
	 * Returns TRUE if size is not a standard paper size.
	 * Returns: whether size is a custom paper size.
	 */
	public int isCustom();
	
	/**
	 * Changes the dimensions of a size to width x height.
	 * Since 2.10
	 * Params:
	 * width =  the new width in units of unit
	 * height =  the new height in units of unit
	 * unit =  the unit for width and height
	 */
	public void setSize(double width, double height, GtkUnit unit);
	
	/**
	 * Gets the default top margin for the GtkPaperSize.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the default top margin
	 */
	public double getDefaultTopMargin(GtkUnit unit);
	
	/**
	 * Gets the default bottom margin for the GtkPaperSize.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the default bottom margin
	 */
	public double getDefaultBottomMargin(GtkUnit unit);
	
	/**
	 * Gets the default left margin for the GtkPaperSize.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the default left margin
	 */
	public double getDefaultLeftMargin(GtkUnit unit);
	
	/**
	 * Gets the default right margin for the GtkPaperSize.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the default right margin
	 */
	public double getDefaultRightMargin(GtkUnit unit);
	
	/**
	 * Returns the name of the default paper size, which
	 * depends on the current locale.
	 * Since 2.10
	 * Returns: the name of the default paper size. The stringis owned by GTK+ and should not be modified.
	 */
	public static string getDefault();
	
	/**
	 * Reads a paper size from the group group_name in the key file
	 * key_file.
	 * Since 2.12
	 * Params:
	 * keyFile =  the GKeyFile to retrieve the papersize from
	 * groupName =  the name ofthe group in the key file to read,
	 *  or NULL to read the first group
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (KeyFile keyFile, string groupName);
	
	/**
	 * This function adds the paper size from size to key_file.
	 * Since 2.12
	 * Params:
	 * keyFile =  the GKeyFile to save the paper size to
	 * groupName =  the group to add the settings to in key_file
	 */
	public void toKeyFile(KeyFile keyFile, string groupName);
}
