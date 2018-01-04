module gtkD.gsv.SourcePrintCompositor;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.gsv.SourceBuffer;
private import gtkD.gsv.SourceView;
private import gtkD.gtk.PrintContext;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * The GtkSourcePrintCompositor object is used to compose a
 * GtkSourceBuffer for printing. You can set various configuration options to
 * customize the printed output. GtkSourcePrintCompositor is designed to be used with
 * the high-level printing API of gtk+, i.e. GtkPrintOperation.
 * The margins specified in this object are the layout margins: they define the blank space
 * bordering the printed area of the pages.
 * They must not be confused with the "print margins", i.e. the parts of the page
 * that the printer cannot print on, defined in the GtkPageSetup objects.
 * If the specified layout margins are smaller than the "print margins", the latter ones are used
 * as a fallback by the GtkSourcePrintCompositor object, so that the printed area is not clipped.
 */
public class SourcePrintCompositor : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourcePrintCompositor* gtkSourcePrintCompositor;
	
	
	public GtkSourcePrintCompositor* getSourcePrintCompositorStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourcePrintCompositor* gtkSourcePrintCompositor);
	
	/**
	 */
	
	/**
	 * Creates a new print compositor that can be used to print buffer.
	 * Since 2.2
	 * Params:
	 * buffer =  the GtkSourceBuffer to print
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (SourceBuffer buffer);
	
	/**
	 * Creates a new print compositor that can be used to print the buffer
	 * associated with view.
	 * This constructor sets some configuration properties to make the
	 * printed output match view as much as possible. The properties set are
	 * "tab-width", "highlight-syntax",
	 * "wrap-mode", "body-font-name" and
	 * "print-line-numbers".
	 * Since 2.2
	 * Params:
	 * view =  a GtkSourceView to get configuration from.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (SourceView view);
	
	/**
	 * Gets the GtkSourceBuffer associated with the compositor. The returned
	 * object reference is owned by the compositor object and
	 * should not be unreferenced.
	 * Since 2.2
	 * Returns: the GtkSourceBuffer associated with the compositor.
	 */
	public SourceBuffer getBuffer();
	
	/**
	 * Sets the width of tabulation in characters for printed text.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * width =  width of tab in characters.
	 */
	public void setTabWidth(uint width);
	
	/**
	 * Returns the width of tabulation in characters for printed text.
	 * Since 2.2
	 * Returns: width of tab.
	 */
	public uint getTabWidth();
	
	/**
	 * Sets the line wrapping mode for the printed text.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * wrapMode =  a GtkWrapMode.
	 */
	public void setWrapMode(GtkWrapMode wrapMode);
	
	/**
	 * Gets the line wrapping mode for the printed text.
	 * Since 2.2
	 * Returns: the line wrap mode.
	 */
	public GtkWrapMode getWrapMode();
	
	/**
	 * Sets whether the printed text will be highlighted according to the
	 * buffer rules. Both color and font style are applied.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * highlight =  whether syntax should be highlighted.
	 */
	public void setHighlightSyntax(int highlight);
	
	/**
	 * Determines whether the printed text will be highlighted according to the
	 * buffer rules. Note that highlighting will happen
	 * only if the buffer to print has highlighting activated.
	 * Since 2.2
	 * Returns: TRUE if the printed output will be highlighted.
	 */
	public int getHighlightSyntax();
	
	/**
	 * Sets the interval for printed line numbers. If interval is 0 no
	 * numbers will be printed. If greater than 0, a number will be
	 * printed every interval lines (i.e. 1 will print all line numbers).
	 * Maximum accepted value for interval is 100.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * interval =  interval for printed line numbers.
	 */
	public void setPrintLineNumbers(uint interval);
	
	/**
	 * Returns the interval used for line number printing. If the
	 * value is 0, no line numbers will be printed. The default value is
	 * 1 (i.e. numbers printed in all lines).
	 * Since 2.2
	 * Returns: the interval of printed line numbers.
	 */
	public uint getPrintLineNumbers();
	
	/**
	 * Sets the default font for the printed text.
	 * font_name should be a
	 * string representation of a font description Pango can understand.
	 * (e.g. "Monospace 10"). See pango_font_description_from_string()
	 * for a description of the format of the string representation.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * fontName =  the name of the default font for the body text.
	 */
	public void setBodyFontName(string fontName);
	
	/**
	 * Returns the name of the font used to print the text body. The returned string
	 * must be freed with g_free().
	 * Since 2.2
	 * Returns: a new string containing the name of the font used to print the text body.
	 */
	public string getBodyFontName();
	
	/**
	 * Sets the font for printing line numbers on the left margin. If
	 * NULL is supplied, the default font (i.e. the one being used for the
	 * text) will be used instead.
	 * font_name should be a
	 * string representation of a font description Pango can understand.
	 * (e.g. "Monospace 10"). See pango_font_description_from_string()
	 * for a description of the format of the string representation.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * fontName =  the name of the font for line numbers, or NULL.
	 */
	public void setLineNumbersFontName(string fontName);
	
	/**
	 * Returns the name of the font used to print line numbers on the left margin.
	 * The returned string must be freed with g_free())
	 * Since 2.2
	 * Returns: a new string containing the name of the font used to print line numbers on the left margin.
	 */
	public string getLineNumbersFontName();
	
	/**
	 * Sets the font for printing the page header. If
	 * NULL is supplied, the default font (i.e. the one being used for the
	 * text) will be used instead.
	 * font_name should be a
	 * string representation of a font description Pango can understand.
	 * (e.g. "Monospace 10"). See pango_font_description_from_string()
	 * for a description of the format of the string representation.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * fontName =  the name of the font for header text, or NULL.
	 */
	public void setHeaderFontName(string fontName);
	
	/**
	 * Returns the name of the font used to print the page header.
	 * The returned string must be freed with g_free())
	 * Since 2.2
	 * Returns: a new string containing the name of the font used to print the page header.
	 */
	public string getHeaderFontName();
	
	/**
	 * Sets the font for printing the page footer. If
	 * NULL is supplied, the default font (i.e. the one being used for the
	 * text) will be used instead.
	 * font_name should be a
	 * string representation of a font description Pango can understand.
	 * (e.g. "Monospace 10"). See pango_font_description_from_string()
	 * for a description of the format of the string representation.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * fontName =  the name of the font for the footer text, or NULL.
	 */
	public void setFooterFontName(string fontName);
	
	/**
	 * Returns the name of the font used to print the page footer.
	 * The returned string must be freed with g_free())
	 * Since 2.2
	 * Returns: a new string containing the name of the font used to print the page footer.
	 */
	public string getFooterFontName();
	
	/**
	 * Gets the top margin in units of unit.
	 * Since 2.2
	 * Params:
	 * unit =  the unit for the return value.
	 * Returns: the top margin.
	 */
	public double getTopMargin(GtkUnit unit);
	
	/**
	 * Sets the top margin used by compositor.
	 * Since 2.2
	 * Params:
	 * margin =  the new top margin in units of unit
	 * unit =  the units for margin
	 */
	public void setTopMargin(double margin, GtkUnit unit);
	
	/**
	 * Gets the bottom margin in units of unit.
	 * Since 2.2
	 * Params:
	 * unit =  the unit for the return value.
	 * Returns: the bottom margin.
	 */
	public double getBottomMargin(GtkUnit unit);
	
	/**
	 * Sets the bottom margin used by compositor.
	 * Since 2.2
	 * Params:
	 * margin =  the new bottom margin in units of unit
	 * unit =  the units for margin
	 */
	public void setBottomMargin(double margin, GtkUnit unit);
	
	/**
	 * Gets the left margin in units of unit.
	 * Since 2.2
	 * Params:
	 * unit =  the unit for the return value.
	 * Returns: the left margin
	 */
	public double getLeftMargin(GtkUnit unit);
	
	/**
	 * Sets the left margin used by compositor.
	 * Since 2.2
	 * Params:
	 * margin =  the new left margin in units of unit
	 * unit =  the units for margin
	 */
	public void setLeftMargin(double margin, GtkUnit unit);
	
	/**
	 * Gets the right margin in units of unit.
	 * Since 2.2
	 * Params:
	 * unit =  the unit for the return value.
	 * Returns: the right margin
	 */
	public double getRightMargin(GtkUnit unit);
	
	/**
	 * Sets the right margin used by compositor.
	 * Since 2.2
	 * Params:
	 * margin =  the new right margin in units of unit
	 * unit =  the units for margin
	 */
	public void setRightMargin(double margin, GtkUnit unit);
	
	/**
	 * Sets whether you want to print a header in each page. The
	 * header consists of three pieces of text and an optional line
	 * separator, configurable with
	 * gtk_source_print_compositor_set_header_format().
	 * Note that by default the header format is unspecified, and if it's
	 * empty it will not be printed, regardless of this setting.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * print =  TRUE if you want the header to be printed.
	 */
	public void setPrintHeader(int print);
	
	/**
	 * Determines if a header is set to be printed for each page. A
	 * header will be printed if this function returns TRUE
	 * and some format strings have been specified
	 * with gtk_source_print_compositor_set_header_format().
	 * Since 2.2
	 * Returns: TRUE if the header is set to be printed.
	 */
	public int getPrintHeader();
	
	/**
	 * Sets whether you want to print a footer in each page. The
	 * footer consists of three pieces of text and an optional line
	 * separator, configurable with
	 * gtk_source_print_compositor_set_footer_format().
	 * Note that by default the footer format is unspecified, and if it's
	 * empty it will not be printed, regardless of this setting.
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * print =  TRUE if you want the footer to be printed.
	 */
	public void setPrintFooter(int print);
	
	/**
	 * Determines if a footer is set to be printed for each page. A
	 * footer will be printed if this function returns TRUE
	 * and some format strings have been specified
	 * with gtk_source_print_compositor_set_footer_format().
	 * Since 2.2
	 * Returns: TRUE if the footer is set to be printed.
	 */
	public int getPrintFooter();
	
	/**
	 * Sets strftime like header format strings, to be printed on the
	 * left, center and right of the top of each page. The strings may
	 * include strftime(3) codes which will be expanded at print time.
	 * All strftime() codes are accepted, with the addition of N for the
	 * page number and Q for the page count.
	 * separator specifies if a solid line should be drawn to separate
	 * the header from the document text.
	 * If NULL is given for any of the three arguments, that particular
	 * string will not be printed.
	 * For the header to be printed, in
	 * addition to specifying format strings, you need to enable header
	 * printing with gtk_source_print_compositor_set_print_header().
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * separator =  TRUE if you want a separator line to be printed.
	 * left =  a format string to print on the left of the header.
	 * center =  a format string to print on the center of the header.
	 * right =  a format string to print on the right of the header.
	 */
	public void setHeaderFormat(int separator, string left, string center, string right);
	
	/**
	 * Sets strftime like header format strings, to be printed on the
	 * left, center and right of the bottom of each page. The strings may
	 * include strftime(3) codes which will be expanded at print time.
	 * All strftime() codes are accepted, with the addition of N for the
	 * page number and Q for the page count.
	 * separator specifies if a solid line should be drawn to separate
	 * the footer from the document text.
	 * If NULL is given for any of the three arguments, that particular
	 * string will not be printed.
	 * For the footer to be printed, in
	 * addition to specifying format strings, you need to enable footer
	 * printing with gtk_source_print_compositor_set_print_footer().
	 * This function cannot be called anymore after the first call to the
	 * gtk_source_print_compositor_paginate() function.
	 * Since 2.2
	 * Params:
	 * separator =  TRUE if you want a separator line to be printed.
	 * left =  a format string to print on the left of the footer.
	 * center =  a format string to print on the center of the footer.
	 * right =  a format string to print on the right of the footer.
	 */
	public void setFooterFormat(int separator, string left, string center, string right);
	
	/**
	 * Returns the number of pages in the document or -1 if the
	 * document has not been completely paginated.
	 * Since 2.2
	 * Returns: the number of pages in the document or -1 if the document has not been completely paginated.
	 */
	public int getNPages();
	
	/**
	 * Paginate the document associated with the compositor.
	 * In order to support non-blocking pagination, document is paginated in small chunks.
	 * Each time gtk_source_print_compositor_paginate() is invoked, a chunk of the document
	 * is paginated. To paginate the entire document, gtk_source_print_compositor_paginate()
	 * must be invoked multiple times.
	 * It returns TRUE if the document has been completely paginated, otherwise it returns FALSE.
	 * This method has been designed to be invoked in the handler of the "paginate" signal,
	 * Since 2.2
	 * Params:
	 * context =  the GtkPrintContext whose parameters (e.g. paper size, print margins, etc.)
	 * are used by the the compositor to paginate the document.
	 * Returns: TRUE if the document has been completely paginated, FALSE otherwise.
	 */
	public int paginate(PrintContext context);
	
	/**
	 * Returns the current fraction of the document pagination that has been completed.
	 * Since 2.2
	 * Returns: a fraction from 0.0 to 1.0 inclusive
	 */
	public double getPaginationProgress();
	
	/**
	 * Draw page page_nr for printing on the the Cairo context encapsuled in context.
	 * This method has been designed to be called in the handler of the "draw_page" signal
	 * Params:
	 * context =  the GtkPrintContext encapsulating the context information that is required when
	 *  drawing the page for printing.
	 * pageNr =  the number of the page to print.
	 */
	public void drawPage(PrintContext context, int pageNr);
}
