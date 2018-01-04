module gtkD.gtk.CellEditableT;

public  import gtkD.gtkc.gtktypes;

public import gtkD.gtkc.gtk;
public import gtkD.glib.ConstructionException;

public import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

public import gtkD.gdk.Event;




/**
 * Description
 * The GtkCellEditable interface must be implemented for widgets
 * to be usable when editing the contents of a GtkTreeView cell.
 */
public template CellEditableT(TStruct)
{
	
	/** the main Gtk struct */
	protected GtkCellEditable* gtkCellEditable;
	
	
	public GtkCellEditable* getCellEditableTStruct()
	{
		return cast(GtkCellEditable*)getStruct();
	}
	
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(CellEditableIF)[] _onEditingDoneListeners;
	void delegate(CellEditableIF)[] onEditingDoneListeners()
	{
		return  _onEditingDoneListeners;
	}
	/**
	 * This signal is a sign for the cell renderer to update its
	 * value from the cell_editable.
	 * Implementations of GtkCellEditable are responsible for
	 * emitting this signal when they are done editing, e.g.
	 * GtkEntry is emitting it when the user presses Enter.
	 * gtk_cell_editable_editing_done() is a convenience method
	 * for emitting ::editing-done.
	 */
	void addOnEditingDone(void delegate(CellEditableIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("editing-done" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"editing-done",
			cast(GCallback)&callBackEditingDone,
			cast(void*)cast(CellEditableIF)this,
			null,
			connectFlags);
			connectedSignals["editing-done"] = 1;
		}
		_onEditingDoneListeners ~= dlg;
	}
	extern(C) static void callBackEditingDone(GtkCellEditable* cellEditableStruct, CellEditableIF cellEditableIF)
	{
		foreach ( void delegate(CellEditableIF) dlg ; cellEditableIF.onEditingDoneListeners )
		{
			dlg(cellEditableIF);
		}
	}
	
	void delegate(CellEditableIF)[] _onRemoveWidgetListeners;
	void delegate(CellEditableIF)[] onRemoveWidgetListeners()
	{
		return  _onRemoveWidgetListeners;
	}
	/**
	 * This signal is meant to indicate that the cell is finished
	 * editing, and the widget may now be destroyed.
	 * Implementations of GtkCellEditable are responsible for
	 * emitting this signal when they are done editing. It must
	 * be emitted after the "editing-done" signal,
	 * to give the cell renderer a chance to update the cell's value
	 * before the widget is removed.
	 * gtk_cell_editable_remove_widget() is a convenience method
	 * for emitting ::remove-widget.
	 */
	void addOnRemoveWidget(void delegate(CellEditableIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("remove-widget" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"remove-widget",
			cast(GCallback)&callBackRemoveWidget,
			cast(void*)cast(CellEditableIF)this,
			null,
			connectFlags);
			connectedSignals["remove-widget"] = 1;
		}
		_onRemoveWidgetListeners ~= dlg;
	}
	extern(C) static void callBackRemoveWidget(GtkCellEditable* cellEditableStruct, CellEditableIF cellEditableIF)
	{
		foreach ( void delegate(CellEditableIF) dlg ; cellEditableIF.onRemoveWidgetListeners )
		{
			dlg(cellEditableIF);
		}
	}
	
	
	/**
	 * Begins editing on a cell_editable. event is the GdkEvent that began
	 * the editing process. It may be NULL, in the instance that editing was
	 * initiated through programatic means.
	 * Params:
	 * event =  A GdkEvent, or NULL
	 */
	public void startEditing(Event event)
	{
		// void gtk_cell_editable_start_editing (GtkCellEditable *cell_editable,  GdkEvent *event);
		gtk_cell_editable_start_editing(getCellEditableTStruct(), (event is null) ? null : event.getEventStruct());
	}
	
	/**
	 * Emits the "editing-done" signal.
	 */
	public void editingDone()
	{
		// void gtk_cell_editable_editing_done (GtkCellEditable *cell_editable);
		gtk_cell_editable_editing_done(getCellEditableTStruct());
	}
	
	/**
	 * Emits the "remove-widget" signal.
	 */
	public void removeWidget()
	{
		// void gtk_cell_editable_remove_widget (GtkCellEditable *cell_editable);
		gtk_cell_editable_remove_widget(getCellEditableTStruct());
	}
}
