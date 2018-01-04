module gtkD.gsv.SourceStyleScheme;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.gsv.SourceStyle;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * GtkSourceStyleScheme contains all the text styles to be used
 * in GtkSourceView and GtkSourceBuffer. For instance, it contains
 * text styles for syntax highlighting, it may contain foreground
 * and background color for non-highlighted text, etc.
 * Style schemes are stored in XML files. The format of scheme file is
 * the following.
 * The toplevel tag in a style scheme file is <style-scheme>.
 * It has the following attributes:
 * id (mandatory)
 * Identifier for the style scheme. This is must be unique among style schemes.
 * name (mandatory)
 * Name of the style scheme. This is the name of the scheme to display to user, e.g.
 * in a preferences dialog.
 * _name
 * This is the same as name attribute, except it will be translated.
 * name and _name may not be used simultaneously.
 * parent-scheme (optional)
 * Style schemes may have parent schemes: all styles but those specified
 * in the scheme will be taken from the parent scheme. In this way a scheme may
 * be customized without copying all its content.
 * version (mandatory)
 * Style scheme format identifier. At the moment it must be "1.0".
 * style-scheme tag may contain the following tags:
 * author
 * Name of the style scheme author.
 * description
 * Description of the style scheme.
 * _description
 * Same as description except it will be localized.
 * color tags
 * These define color names to be used in style tags.
 * It has two attributes: name and value.
 * value is the hexadecimal color specification like
 * "#000000" or named color understood by Gdk prefixed with "#",
 * e.g. "#beige".
 * style tags
 * See below for their format description.
 * Each style tag describes a single element of style scheme (it corresponds
 * to GtkSourceStyle object). It has the following attributes:
 * name (mandatory)
 * Name of the style. It can be anything, syntax highlighting uses lang-id:style-id,
 * and there are few special styles which are used to control general appearance
 * of the text. Style scheme may contain other names to be used in an application. For instance,
 * it may define color to highlight compilation errors in a build log or a color for
 * bookmarks.
 * foreground
 * Foreground color. It may be name defined in one of color tags, or value in
 * hexadecimal format, e.g. "#000000", or symbolic name understood
 * by Gdk, prefixed with "#", e.g. "#magenta" or "#darkred".
 * background
 * Background color.
 * italic
 * "true" or "false"
 * bold
 * "true" or "false"
 * underline
 * "true" or "false"
 * strikethrough
 * "true" or "false"
 * The following are names of styles which control GtkSourceView appearance:
 * text
 * Default style of text.
 * selection
 * Style of selected text.
 * selection-unfocused
 * Style of selected text when the widget doesn't have input focus.
 * cursor
 * Text cursor style. Only foreground attribute is used
 * for this style
 * secondary-cursor
 * Secondary cursor style (used in bidi text). Only foreground attribute
 * is used for this style. If this is not set while "cursor" is, then a color between text background
 * and cursor colors is chosen, so it is enough to use "cursor" style only.
 * current-line
 * Current line style. Only background attribute is used
 * line-numbers
 * Text and background colors for the left margin, on which line numbers are
 * drawn
 * bracket-match
 * Style to use for matching brackets.
 * bracket-mismatch
 * Style to use for mismatching brackets.
 */
public class SourceStyleScheme : ObjectG
{
	
	/** the main Gtk struct */
	protected GtkSourceStyleScheme* gtkSourceStyleScheme;
	
	
	public GtkSourceStyleScheme* getSourceStyleSchemeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkSourceStyleScheme* gtkSourceStyleScheme);
	
	/**
	 */
	
	/**
	 * Since 2.0
	 * Returns: scheme id.
	 */
	public string getId();
	
	/**
	 * Since 2.0
	 * Returns: scheme name.
	 */
	public string getName();
	
	/**
	 * Since 2.0
	 * Returns: scheme description (if defined) or NULL.
	 */
	public string getDescription();
	
	/**
	 * Since 2.0
	 * Returns: a NULL-terminated array containing the scheme authors orNULL if no author is specified by the stylescheme.
	 */
	public string[] getAuthors();
	
	/**
	 * Since 2.0
	 * Returns: scheme file name if the scheme was created parsing astyle scheme file or NULL in the other cases.
	 */
	public string getFilename();
	
	/**
	 * Since 2.0
	 * Params:
	 * styleId =  id of the style to retrieve.
	 * Returns: style which corresponds to style_id in the scheme,or NULL when no style with this name found. It is owned by schemeand may not be unref'ed.
	 */
	public SourceStyle getStyle(string styleId);
}
