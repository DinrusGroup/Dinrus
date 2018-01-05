module gtkD.gtk.TreeModel;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Type;
private import gtkD.gobject.ObjectG;
private import gtkD.gobject.Signals;
private import gtkD.gobject.Value;
private import gtkD.gtk.TreeIter;
private import gtkD.gtk.TreePath;
private import gtkD.gtk.TreeModelT;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtkc.gobject;
private import gtkD.gtkc.Loader;
private import gtkD.gtkc.paths;




struct CustomTreeModelClass
{
	GObjectClass parentClass;
}

//We need this function for the interface implementation.
extern(C) typedef GType function()c_gtk_tree_model_get_type;
c_gtk_tree_model_get_type gtk_tree_model_get_type;

/**
 */
public class TreeModel : ObjectG, TreeModelIF
{
	static GObjectClass* parentClass = null;
	
	static this()
	{
		Linker.link(gtk_tree_model_get_type, "gtk_tree_model_get_type", LIBRARY.GTK);
	}
	
	// Minimal implementation.
	mixin TreeModelT!(GtkTreeModel);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct();
	
	public this ();
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeModel* gtkTreeModel);
	
	
	extern(C)
	{
		/*
		 *  here we register our new type and its interfaces
		 *  with the type system. If you want to implement
		 *  additional interfaces like GtkTreeSortable, you
		 *  will need to do it here.
		 */
		
		static GType customTreeModelgetType();
		
		/*
		 *  boilerplate GObject/GType stuff.
		 *  Init callback for the type system,
		 *  called once when our new class is created.
		 */
		
		static void customTreeModelClassInit (void* klass);
		
		/*
		 *  init callback for the interface registration
		 *  in customTreeModelGetType. Here we override
		 *  the GtkTreeModel interface functions that
		 *  we implement.
		 */
		
		static void customTreeModelInit (GtkTreeModelIface *iface);
		
		/*
		 *  this is called just before a custom list is
		 *  destroyed. Free dynamically allocated memory here.
		 */
		
		static void customTreeModelFinalize (GObject *object);
		
		static GtkTreeModelFlags customTreeModelGetFlags(GtkTreeModel *tree_model);
		
		static int customTreeModelGetNColumns(GtkTreeModel *tree_model);
		
		static GType customTreeModelGetColumnType(GtkTreeModel *tree_model, int index);
		
		static gboolean customTreeModelGetIter(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path);
		
		static GtkTreePath* customTreeModelGetPath(GtkTreeModel *tree_model, GtkTreeIter *iter);
		
		static void customTreeModelGetValue(GtkTreeModel *tree_model, GtkTreeIter *iter, int column, GValue *value);
		
		static gboolean customTreeModelIterNext(GtkTreeModel *tree_model, GtkTreeIter *iter);
		
		static gboolean customTreeModelIterChildren(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent);
		
		static gboolean customTreeModelIterHasChild(GtkTreeModel *tree_model, GtkTreeIter *iter);
		
		static int customTreeModelIterNChildren(GtkTreeModel *tree_model, GtkTreeIter *iter);
		
		static gboolean customTreeModelIterNthChild(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, int n);
		
		static gboolean customTreeModelIterParent(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *child);
	}
}

/**
 */

