
module gtkD.glade.Glade;

public  import gtkD.gtkc.gladetypes;

private import gtkD.gtkc.glade;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.Widget;
private import gtkD.gobject.ObjectG;
private import gtkD.glib.ListG;
private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 * This object represents an `instantiation' of an XML interface description.
 * When one of these objects is created, the XML file is read, and the
 * interface is created. The GladeXML object then provides an interface for
 * accessing the widgets in the interface by the names assigned to them
 * inside the XML description.
 * The GladeXML object can also be used to connect handlers to the named
 * signals in the description. Libglade also provides an interface by which
 * it can look up the signal handler names in the program's symbol table and
 * automatically connect as many handlers up as it can that way.
 */
public class Glade : ObjectG
{
	
	/** the main Gtk struct */
	protected GladeXML* gladeXML;
	
	
	public GladeXML* getGladeStruct();
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GladeXML* gladeXML);
	
	/**
	 * This function is used to get a pointer to the GtkWidget corresponding to
	 * name in the interface description. You would use this if you have to do
	 * anything to the widget after loading.
	 * Params:
	 *  name = the name of the widget.
	 * Returns:
	 *  the widget matching name, or NULL if none exists.
	 */
	public Widget getWidget(string name);
	
	
	
	
	
	
	/**
	 * Creates a new GladeXML object (and the corresponding widgets) from the
	 * XML file fname. Optionally it will only build the interface from the
	 * widget node root (if it is not NULL). This feature is useful if you
	 * only want to build say a toolbar or menu from the XML file, but not the
	 * window it is embedded in. Note also that the XML parse tree is cached
	 * to speed up creating another GladeXML object for the same file
	 * Params:
	 *  fname = the XML file name.
	 *  root = the widget node in fname to start building from (or NULL)
	 *  domain = the translation domain for the XML file (or NULL for default)
	 */
	public this (string fname, string root = null, string domain=null);
	
	/**
	 * This function is used to get a list of pointers to the GtkWidget(s)
	 * with names that start with the string name in the interface description.
	 * You would use this if you have to do something to all of these widgets
	 * after loading.
	 * Params:
	 *  name = the name of the widget.
	 * Returns:
	 *  A list of the widget that match name as the start of their
	 *  name, or NULL if none exists.
	 */
	public Widget[] getWidgetPrefix(string name);
	
	
	private import gtkD.gobject.Type;
	private import gtkD.gtk.AboutDialog;
	private import gtkD.gtk.AccelLabel;
	private import gtkD.gtk.Alignment;
	private import gtkD.gtk.Arrow;
	private import gtkD.gtk.AspectFrame;
	private import gtkD.gtk.Assistant;
	private import gtkD.gtk.Bin;
	private import gtkD.gtk.Box;
	private import gtkD.gtk.ButtonBox;
	private import gtkD.gtk.Button;
	private import gtkD.gtk.Calendar;
	private import gtkD.gtk.CellView;
	private import gtkD.gtk.CheckButton;
	private import gtkD.gtk.CheckMenuItem;
	private import gtkD.gtk.ColorButton;
	private import gtkD.gtk.ColorSelection;
	private import gtkD.gtk.ColorSelectionDialog;
	private import gtkD.gtk.ComboBox;
	private import gtkD.gtk.ComboBoxEntry;
	private import gtkD.gtk.Container;
	private import gtkD.gtk.Curve;
	private import gtkD.gtk.Dialog;
	private import gtkD.gtk.DrawingArea;
	private import gtkD.gtk.Entry;
	private import gtkD.gtk.EventBox;
	private import gtkD.gtk.Expander;
	private import gtkD.gtk.FileChooserButton;
	private import gtkD.gtk.FileChooserDialog;
	private import gtkD.gtk.FileChooserWidget;
	private import gtkD.gtk.FileSelection;
	private import gtkD.gtk.Fixed;
	private import gtkD.gtk.FontButton;
	private import gtkD.gtk.FontSelection;
	private import gtkD.gtk.FontSelectionDialog;
	private import gtkD.gtk.Frame;
	private import gtkD.gtk.GammaCurve;
	private import gtkD.gtk.HandleBox;
	private import gtkD.gtk.HBox;
	private import gtkD.gtk.HButtonBox;
	private import gtkD.gtk.HPaned;
	private import gtkD.gtk.HRuler;
	private import gtkD.gtk.HScale;
	private import gtkD.gtk.HScrollbar;
	private import gtkD.gtk.HSeparator;
	private import gtkD.gtk.IconView;
	private import gtkD.gtk.Image;
	private import gtkD.gtk.ImageMenuItem;
	private import gtkD.gtk.InputDialog;
	private import gtkD.gtk.Invisible;
	private import gtkD.gtk.Item;
	private import gtkD.gtk.Label;
	private import gtkD.gtk.Layout;
	private import gtkD.gtk.LinkButton;
	private import gtkD.gtk.MenuBar;
	private import gtkD.gtk.Menu;
	private import gtkD.gtk.MenuItem;
	private import gtkD.gtk.MenuShell;
	private import gtkD.gtk.MenuToolButton;
	private import gtkD.gtk.MessageDialog;
	private import gtkD.gtk.Misc;
	private import gtkD.gtk.Notebook;
	private import gtkD.gtk.PageSetupUnixDialog;
	private import gtkD.gtk.Paned;
	private import gtkD.gtk.Plug;
	private import gtkD.gtk.PrintUnixDialog;
	private import gtkD.gtk.ProgressBar;
	private import gtkD.gtk.Progress;
	private import gtkD.gtk.RadioButton;
	private import gtkD.gtk.RadioMenuItem;
	private import gtkD.gtk.RadioToolButton;
	private import gtkD.gtk.Range;
	private import gtkD.gtk.RecentChooserDialog;
	private import gtkD.gtk.RecentChooserMenu;
	private import gtkD.gtk.RecentChooserWidget;
	private import gtkD.gtk.Ruler;
	private import gtkD.gtk.ScaleButton;
	private import gtkD.gtk.Scale;
	private import gtkD.gtk.Scrollbar;
	private import gtkD.gtk.ScrolledWindow;
	private import gtkD.gtk.Separator;
	private import gtkD.gtk.SeparatorMenuItem;
	private import gtkD.gtk.SeparatorToolItem;
	private import gtkD.gtk.Socket;
	private import gtkD.gtk.SpinButton;
	private import gtkD.gtk.Statusbar;
	private import gtkD.gtk.Table;
	private import gtkD.gtk.TearoffMenuItem;
	private import gtkD.gtk.TextView;
	private import gtkD.gtk.ToggleButton;
	private import gtkD.gtk.ToggleToolButton;
	private import gtkD.gtk.Toolbar;
	private import gtkD.gtk.ToolButton;
	private import gtkD.gtk.ToolItem;
	private import gtkD.gtk.TreeView;
	private import gtkD.gtk.VBox;
	private import gtkD.gtk.VButtonBox;
	private import gtkD.gtk.Viewport;
	private import gtkD.gtk.VolumeButton;
	private import gtkD.gtk.VPaned;
	private import gtkD.gtk.VRuler;
	private import gtkD.gtk.VScale;
	private import gtkD.gtk.VScrollbar;
	private import gtkD.gtk.VSeparator;
	private import gtkD.gtk.Widget;
	private import gtkD.gtk.Window;
	
	/**
	 * Utilitiy method to create objects that are castable.
	 *
	 */
	Widget newFromWidget(GtkWidget* ptr);
	
	
	/**
	 * Description
	 * These routines are used to initialise libglade, and to load addon modules
	 * that recognise extra widget sets. The glade_init
	 * routine must be called before any libglade routines are used, and the
	 * glade_load_module routine would be used to load
	 * extra modules.
	 */
	
	/**
	 * Creates a new GladeXML object (and the corresponding widgets) from the
	 * buffer buffer. Optionally it will only build the interface from the
	 * widget node root (if it is not NULL). This feature is useful if you
	 * only want to build say a toolbar or menu from the XML document, but not the
	 * window it is embedded in.
	 * Params:
	 * buffer =  the memory buffer containing the XML document.
	 * size =  the size of the buffer.
	 * root =  the widget node in buffer to start building from (or NULL)
	 * domain =  the translation domain to use for this interface (or NULL)
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string buffer, int size, string root, string domain);
	
	/**
	 * This routine can be used by bindings (such as gtk--) to help construct
	 * a GladeXML object, if it is needed.
	 * Params:
	 * fname =  the XML filename
	 * root =  the root widget node (or NULL for none)
	 * domain =  the translation domain (or NULL for the default)
	 * Returns: TRUE if the construction succeeded.
	 */
	public int construct(string fname, string root, string domain);
	
	/**
	 * Used to get the name of a widget that was generated by a GladeXML object.
	 * Params:
	 * widget =  the widget
	 * Returns: the name of the widget.
	 */
	public static string gladeGetWidgetName(Widget widget);
	
	/**
	 * This function is used to get the GladeXML object that built this widget.
	 * Params:
	 * widget =  the widget
	 * Returns: the GladeXML object that built this widget.
	 */
	public static Glade gladeGetWidgetTree(Widget widget);
	
	/**
	 * It used to be necessary to call glade_init() before creating
	 * GladeXML objects. This is now no longer the case, as libglade will
	 * be initialised on demand now. Calling glade_init() manually will
	 * not cause any problems though.
	 */
	public static void init();
	
	/**
	 * Ensure that a required library is available. If it is not already
	 * available, libglade will attempt to dynamically load a module that
	 * contains the handlers for that library.
	 * Params:
	 * library =  the required library
	 */
	public static void require(string library);
	
	/**
	 * This function should be called by a module to assert that it
	 * provides wrappers for a particular library. This should be called
	 * by the register_widgets() function of a libglade module so that it
	 * isn't loaded twice, for instance.
	 * Params:
	 * library =  the provided library
	 */
	public static void provide(string library);
}
