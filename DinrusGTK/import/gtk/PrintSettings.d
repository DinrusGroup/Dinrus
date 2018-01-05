module gtkD.gtk.PrintSettings;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gtk.PaperSize;
private import gtkD.glib.ErrorG;
private import gtkD.glib.GException;
private import gtkD.glib.KeyFile;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * A GtkPrintSettings object represents the settings of a print dialog in
 * a system-independent way. The main use for this object is that once
 * you've printed you can get a settings object that represents the settings
 * the user chose, and the next time you print you can pass that object in so
 * that the user doesn't have to re-set all his settings.
 * Its also possible to enumerate the settings so that you can easily save
 * the settings for the next time your app runs, or even store them in a
 * document. The predefined keys try to use shared values as much as possible
 * so that moving such a document between systems still works.
 * Printing support was added in GTK+ 2.10.
 */
public class PrintSettings : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkPrintSettings* gtkPrintSettings;
	
	
	public GtkPrintSettings* getPrintSettingsStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkPrintSettings* gtkPrintSettings);
	
	/**
	 */
	
	/**
	 * Creates a new GtkPrintSettings object.
	 * Since 2.10
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ();
	
	/**
	 * Copies a GtkPrintSettings object.
	 * Since 2.10
	 * Returns: a newly allocated copy of other
	 */
	public PrintSettings copy();
	
	/**
	 * Returns TRUE, if a value is associated with key.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * Returns: TRUE, if key has a value
	 */
	public int hasKey(string key);
	
	/**
	 * Looks up the string value associated with key.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * Returns: the string value for key
	 */
	public string get(string key);
	
	/**
	 * Associates value with key.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * value =  a string value, or NULL
	 */
	public void set(string key, string value);
	
	/**
	 * Removes any value associated with key.
	 * This has the same effect as setting the value to NULL.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 */
	public void unset(string key);
	
	/**
	 * Calls func for each key-value pair of settings.
	 * Since 2.10
	 * Params:
	 * func =  the function to call
	 * userData =  user data for func
	 */
	public void foreac(GtkPrintSettingsFunc func, void* userData);
	
	/**
	 * Returns the boolean represented by the value
	 * that is associated with key.
	 * The string "true" represents TRUE, any other
	 * string FALSE.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * Returns: TRUE, if key maps to a true value.
	 */
	public int getBool(string key);
	
	/**
	 * Sets key to a boolean value.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * value =  a boolean
	 */
	public void setBool(string key, int value);
	
	/**
	 * Returns the double value associated with key, or 0.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * Returns: the double value of key
	 */
	public double getDouble(string key);
	
	/**
	 * Returns the floating point number represented by
	 * the value that is associated with key, or default_val
	 * if the value does not represent a floating point number.
	 * Floating point numbers are parsed with g_ascii_strtod().
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * def =  the default value
	 * Returns: the floating point number associated with key
	 */
	public double getDoubleWithDefault(string key, double def);
	
	/**
	 * Sets key to a double value.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * value =  a double value
	 */
	public void setDouble(string key, double value);
	
	/**
	 * Returns the value associated with key, interpreted
	 * as a length. The returned value is converted to units.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * unit =  the unit of the return value
	 * Returns: the length value of key, converted to unit
	 */
	public double getLength(string key, GtkUnit unit);
	
	/**
	 * Associates a length in units of unit with key.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * value =  a length
	 * unit =  the unit of length
	 */
	public void setLength(string key, double value, GtkUnit unit);
	
	/**
	 * Returns the integer value of key, or 0.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * Returns: the integer value of key
	 */
	public int getInt(string key);
	
	/**
	 * Returns the value of key, interpreted as
	 * an integer, or the default value.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * def =  the default value
	 * Returns: the integer value of key
	 */
	public int getIntWithDefault(string key, int def);
	
	/**
	 * Sets key to an integer value.
	 * Since 2.10
	 * Params:
	 * key =  a key
	 * value =  an integer
	 */
	public void setInt(string key, int value);
	
	/**
	 * Convenience function to obtain the value of
	 * GTK_PRINT_SETTINGS_PRINTER.
	 * Since 2.10
	 * Returns: the printer name
	 */
	public string getPrinter();
	
	/**
	 * Convenience function to set GTK_PRINT_SETTINGS_PRINTER
	 * to printer.
	 * Since 2.10
	 * Params:
	 * printer =  the printer name
	 */
	public void setPrinter(string printer);

	/**
	 * Get the value of GTK_PRINT_SETTINGS_ORIENTATION,
	 * converted to a GtkPageOrientation.
	 * Since 2.10
	 * Returns: the orientation
	 */
	public GtkPageOrientation getOrientation();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_ORIENTATION.
	 * Since 2.10
	 * Params:
	 * orientation =  a page orientation
	 */
	public void setOrientation(GtkPageOrientation orientation);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PAPER_FORMAT,
	 * converted to a GtkPaperSize.
	 * Since 2.10
	 * Returns: the paper size
	 */
	public PaperSize getPaperSize();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PAPER_FORMAT,
	 * GTK_PRINT_SETTINGS_PAPER_WIDTH and
	 * GTK_PRINT_SETTINGS_PAPER_HEIGHT.
	 * Since 2.10
	 * Params:
	 * paperSize =  a paper size
	 */
	public void setPaperSize(PaperSize paperSize);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PAPER_WIDTH,
	 * converted to unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the paper width, in units of unit
	 */
	public double getPaperWidth(GtkUnit unit);
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PAPER_WIDTH.
	 * Since 2.10
	 * Params:
	 * width =  the paper width
	 * unit =  the units of width
	 */
	public void setPaperWidth(double width, GtkUnit unit);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PAPER_HEIGHT,
	 * converted to unit.
	 * Since 2.10
	 * Params:
	 * unit =  the unit for the return value
	 * Returns: the paper height, in units of unit
	 */
	public double getPaperHeight(GtkUnit unit);
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PAPER_HEIGHT.
	 * Since 2.10
	 * Params:
	 * height =  the paper height
	 * unit =  the units of height
	 */
	public void setPaperHeight(double height, GtkUnit unit);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_USE_COLOR.
	 * Since 2.10
	 * Returns: whether to use color
	 */
	public int getUseColor();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_USE_COLOR.
	 * Since 2.10
	 * Params:
	 * useColor =  whether to use color
	 */
	public void setUseColor(int useColor);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_COLLATE.
	 * Since 2.10
	 * Returns: whether to collate the printed pages
	 */
	public int getCollate();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_COLLATE.
	 * Since 2.10
	 * Params:
	 * collate =  whether to collate the output
	 */
	public void setCollate(int collate);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_REVERSE.
	 * Since 2.10
	 * Returns: whether to reverse the order of the printed pages
	 */
	public int getReverse();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_REVERSE.
	 * Since 2.10
	 * Params:
	 * reverse =  whether to reverse the output
	 */
	public void setReverse(int reverse);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_DUPLEX.
	 * Since 2.10
	 * Returns: whether to print the output in duplex.
	 */
	public GtkPrintDuplex getDuplex();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_DUPLEX.
	 * Since 2.10
	 * Params:
	 * duplex =  a GtkPrintDuplex value
	 */
	public void setDuplex(GtkPrintDuplex duplex);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_QUALITY.
	 * Since 2.10
	 * Returns: the print quality
	 */
	public GtkPrintQuality getQuality();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_QUALITY.
	 * Since 2.10
	 * Params:
	 * quality =  a GtkPrintQuality value
	 */
	public void setQuality(GtkPrintQuality quality);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_N_COPIES.
	 * Since 2.10
	 * Returns: the number of copies to print
	 */
	public int getNCopies();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_N_COPIES.
	 * Since 2.10
	 * Params:
	 * numCopies =  the number of copies
	 */
	public void setNCopies(int numCopies);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_NUMBER_UP.
	 * Since 2.10
	 * Returns: the number of pages per sheet
	 */
	public int getNumberUp();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_NUMBER_UP.
	 * Since 2.10
	 * Params:
	 * numberUp =  the number of pages per sheet
	 */
	public void setNumberUp(int numberUp);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_NUMBER_UP_LAYOUT.
	 * Since 2.14
	 * Returns: layout of page in number-up mode
	 */
	public GtkNumberUpLayout getNumberUpLayout();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_NUMBER_UP_LAYOUT.
	 * Since 2.14
	 * Params:
	 * numberUpLayout =  a GtkNumberUpLayout value
	 */
	public void setNumberUpLayout(GtkNumberUpLayout numberUpLayout);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_RESOLUTION.
	 * Since 2.10
	 * Returns: the resolution in dpi
	 */
	public int getResolution();
	
	/**
	 * Sets the values of GTK_PRINT_SETTINGS_RESOLUTION,
	 * GTK_PRINT_SETTINGS_RESOLUTION_X and
	 * GTK_PRINT_SETTINGS_RESOLUTION_Y.
	 * Since 2.10
	 * Params:
	 * resolution =  the resolution in dpi
	 */
	public void setResolution(int resolution);
	
	/**
	 * Sets the values of GTK_PRINT_SETTINGS_RESOLUTION,
	 * GTK_PRINT_SETTINGS_RESOLUTION_X and
	 * GTK_PRINT_SETTINGS_RESOLUTION_Y.
	 * Since 2.16
	 * Params:
	 * resolutionX =  the horizontal resolution in dpi
	 * resolutionY =  the vertical resolution in dpi
	 */
	public void setResolutionXy(int resolutionX, int resolutionY);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_RESOLUTION_X.
	 * Since 2.16
	 * Returns: the horizontal resolution in dpi
	 */
	public int getResolutionX();
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_RESOLUTION_Y.
	 * Since 2.16
	 * Returns: the vertical resolution in dpi
	 */
	public int getResolutionY();
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PRINTER_LPI.
	 * Since 2.16
	 * Returns: the resolution in lpi (lines per inch)
	 */
	public double getPrinterLpi();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PRINTER_LPI.
	 * Since 2.16
	 * Params:
	 * lpi =  the resolution in lpi (lines per inch)
	 */
	public void setPrinterLpi(double lpi);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_SCALE.
	 * Since 2.10
	 * Returns: the scale in percent
	 */
	public double getScale();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_SCALE.
	 * Since 2.10
	 * Params:
	 * scale =  the scale in percent
	 */
	public void setScale(double scale);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PRINT_PAGES.
	 * Since 2.10
	 * Returns: which pages to print
	 */
	public GtkPrintPages getPrintPages();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PRINT_PAGES.
	 * Since 2.10
	 * Params:
	 * pages =  a GtkPrintPages value
	 */
	public void setPrintPages(GtkPrintPages pages);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PAGE_RANGES.
	 * Since 2.10
	 * Returns: an array of GtkPageRanges. Use g_free() to free the array when it is no longer needed.
	 */
	public GtkPageRange[] getPageRanges();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PAGE_RANGES.
	 * Since 2.10
	 * Params:
	 * pageRanges =  an array of GtkPageRanges
	 */
	public void setPageRanges(GtkPageRange[] pageRanges);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_PAGE_SET.
	 * Since 2.10
	 * Returns: the set of pages to print
	 */
	public GtkPageSet getPageSet();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_PAGE_SET.
	 * Since 2.10
	 * Params:
	 * pageSet =  a GtkPageSet value
	 */
	public void setPageSet(GtkPageSet pageSet);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_DEFAULT_SOURCE.
	 * Since 2.10
	 * Returns: the default source
	 */
	public string getDefaultSource();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_DEFAULT_SOURCE.
	 * Since 2.10
	 * Params:
	 * defaultSource =  the default source
	 */
	public void setDefaultSource(string defaultSource);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_MEDIA_TYPE.
	 * The set of media types is defined in PWG 5101.1-2002 PWG.
	 * Since 2.10
	 * Returns: the media type
	 */
	public string getMediaType();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_MEDIA_TYPE.
	 * The set of media types is defined in PWG 5101.1-2002 PWG.
	 * Since 2.10
	 * Params:
	 * mediaType =  the media type
	 */
	public void setMediaType(string mediaType);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_DITHER.
	 * Since 2.10
	 * Returns: the dithering that is used
	 */
	public string getDither();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_DITHER.
	 * Since 2.10
	 * Params:
	 * dither =  the dithering that is used
	 */
	public void setDither(string dither);

	/**
	 * Gets the value of GTK_PRINT_SETTINGS_FINISHINGS.
	 * Since 2.10
	 * Returns: the finishings
	 */
	public string getFinishings();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_FINISHINGS.
	 * Since 2.10
	 * Params:
	 * finishings =  the finishings
	 */
	public void setFinishings(string finishings);
	
	/**
	 * Gets the value of GTK_PRINT_SETTINGS_OUTPUT_BIN.
	 * Since 2.10
	 * Returns: the output bin
	 */
	public string getOutputBin();
	
	/**
	 * Sets the value of GTK_PRINT_SETTINGS_OUTPUT_BIN.
	 * Since 2.10
	 * Params:
	 * outputBin =  the output bin
	 */
	public void setOutputBin(string outputBin);
	
	/**
	 * Reads the print settings from file_name. Returns a new GtkPrintSettings
	 * object with the restored settings, or NULL if an error occurred.
	 * See gtk_print_settings_to_file().
	 * Since 2.12
	 * Params:
	 * fileName =  the filename to read the settings from
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string fileName);
	
	/**
	 * Reads the print settings from the group group_name in key_file.
	 * Returns a new GtkPrintSettings object with the restored settings,
	 * or NULL if an error occurred.
	 * Since 2.12
	 * Params:
	 * keyFile =  the GKeyFile to retrieve the settings from
	 * groupName =  the name of the group to use, or NULL to use
	 *  the default "Print Settings"
	 * Throws: GException on failure.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (KeyFile keyFile, string groupName);
	
	/**
	 * Reads the print settings from file_name.
	 * See gtk_print_settings_to_file().
	 * Since 2.14
	 * Params:
	 * fileName =  the filename to read the settings from
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int loadFile(string fileName);
	
	/**
	 * Reads the print settings from the group group_name in key_file.
	 * Since 2.14
	 * Params:
	 * keyFile =  the GKeyFile to retrieve the settings from
	 * groupName =  the name of the group to use, or NULL to use the default
	 *  "Print Settings"
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int loadKeyFile(KeyFile keyFile, string groupName);
	
	/**
	 * This function saves the print settings from settings to file_name.
	 * Since 2.12
	 * Params:
	 * fileName =  the file to save to
	 * Returns: TRUE on success
	 * Throws: GException on failure.
	 */
	public int toFile(string fileName);
	
	/**
	 * This function adds the print settings from settings to key_file.
	 * Since 2.12
	 * Params:
	 * keyFile =  the GKeyFile to save the print settings to
	 * groupName =  the group to add the settings to in key_file, or
	 *  NULL to use the default "Print Settings"
	 */
	public void toKeyFile(KeyFile keyFile, string groupName);
}
