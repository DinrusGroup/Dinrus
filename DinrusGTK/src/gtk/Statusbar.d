/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = GtkStatusbar.html
 * outPack = gtk
 * outFile = Statusbar
 * strct   = GtkStatusbar
 * realStrct=
 * ctorStrct=
 * clss    = Statusbar
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_statusbar_
 * 	- gtk_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.Statusbar;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;



private import gtkD.gtk.HBox;

/**
 * Description
 * A GtkStatusbar is usually placed along the bottom of an application's main
 * GtkWindow. It may provide a regular commentary of the application's status
 * (as is usually the case in a web browser, for example), or may be used to
 * simply output a message when the status changes, (when an upload is complete
 * in an FTP client, for example).
 * It may also have a resize grip (a triangular area in the lower right corner)
 * which can be clicked on to resize the window containing the statusbar.
 * Status bars in GTK+ maintain a stack of messages. The message at
 * the top of the each bar's stack is the one that will currently be displayed.
 * Any messages added to a statusbar's stack must specify a context
 * id that is used to uniquely identify the source of a message.
 * This context id can be generated by gtk_statusbar_get_context_id(), given a
 * message and the statusbar that it will be added to. Note that messages are
 * stored in a stack, and when choosing which message to display, the stack
 * structure is adhered to, regardless of the context identifier of a message.
 * One could say that a statusbar maintains one stack of messages for display
 * purposes, but allows multiple message producers to maintain sub-stacks of
 * the messages they produced (via context ids).
 * Status bars are created using gtk_statusbar_new().
 * Messages are added to the bar's stack with gtk_statusbar_push().
 * The message at the top of the stack can be removed using gtk_statusbar_pop().
 * A message can be removed from anywhere in the stack if its message_id was
 * recorded at the time it was added. This is done using gtk_statusbar_remove().
 */
public class Statusbar : HBox
{
	
	/** the main Gtk struct */
	protected GtkStatusbar* gtkStatusbar;
	
	
	public GtkStatusbar* getStatusbarStruct()
	{
		return gtkStatusbar;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkStatusbar;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkStatusbar* gtkStatusbar)
	{
		if(gtkStatusbar is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gtkStatusbar);
		if( ptr !is null )
		{
			this = cast(Statusbar)ptr;
			return;
		}
		super(cast(GtkHBox*)gtkStatusbar);
		this.gtkStatusbar = gtkStatusbar;
	}
	
	/**
	 */
	int[char[]] connectedSignals;
	
	void delegate(guint, string, Statusbar)[] onTextPoppedListeners;
	/**
	 * Is emitted whenever a new message is popped off a statusbar's stack.
	 */
	void addOnTextPopped(void delegate(guint, string, Statusbar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("text-popped" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"text-popped",
			cast(GCallback)&callBackTextPopped,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["text-popped"] = 1;
		}
		onTextPoppedListeners ~= dlg;
	}
	extern(C) static void callBackTextPopped(GtkStatusbar* statusbarStruct, guint contextId, gchar* text, Statusbar statusbar)
	{
		foreach ( void delegate(guint, string, Statusbar) dlg ; statusbar.onTextPoppedListeners )
		{
			dlg(contextId, Str.toString(text), statusbar);
		}
	}
	
	void delegate(guint, string, Statusbar)[] onTextPushedListeners;
	/**
	 * Is emitted whenever a new message gets pushed onto a statusbar's stack.
	 */
	void addOnTextPushed(void delegate(guint, string, Statusbar) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0)
	{
		if ( !("text-pushed" in connectedSignals) )
		{
			Signals.connectData(
			getStruct(),
			"text-pushed",
			cast(GCallback)&callBackTextPushed,
			cast(void*)this,
			null,
			connectFlags);
			connectedSignals["text-pushed"] = 1;
		}
		onTextPushedListeners ~= dlg;
	}
	extern(C) static void callBackTextPushed(GtkStatusbar* statusbarStruct, guint contextId, gchar* text, Statusbar statusbar)
	{
		foreach ( void delegate(guint, string, Statusbar) dlg ; statusbar.onTextPushedListeners )
		{
			dlg(contextId, Str.toString(text), statusbar);
		}
	}
	
	
	/**
	 * Creates a new GtkStatusbar ready for messages.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GtkWidget* gtk_statusbar_new (void);
		auto p = gtk_statusbar_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_statusbar_new()");
		}
		this(cast(GtkStatusbar*) p);
	}
	
	/**
	 * Returns a new context identifier, given a description
	 * of the actual context. Note that the description is
	 * not shown in the UI.
	 * Params:
	 * contextDescription =  textual description of what context
	 *  the new message is being used in
	 * Returns: an integer id
	 */
	public uint getContextId(string contextDescription)
	{
		// guint gtk_statusbar_get_context_id (GtkStatusbar *statusbar,  const gchar *context_description);
		return gtk_statusbar_get_context_id(gtkStatusbar, Str.toStringz(contextDescription));
	}
	
	/**
	 * Pushes a new message onto a statusbar's stack.
	 * Params:
	 * contextId =  the message's context id, as returned by
	 *  gtk_statusbar_get_context_id()
	 * text =  the message to add to the statusbar
	 * Returns: a message id that can be used with  gtk_statusbar_remove().
	 */
	public uint push(uint contextId, string text)
	{
		// guint gtk_statusbar_push (GtkStatusbar *statusbar,  guint context_id,  const gchar *text);
		return gtk_statusbar_push(gtkStatusbar, contextId, Str.toStringz(text));
	}
	
	/**
	 * Removes the first message in the GtkStatusBar's stack
	 * with the given context id.
	 * Note that this may not change the displayed message, if
	 * the message at the top of the stack has a different
	 * context id.
	 * Params:
	 * contextId =  a context identifier
	 */
	public void pop(uint contextId)
	{
		// void gtk_statusbar_pop (GtkStatusbar *statusbar,  guint context_id);
		gtk_statusbar_pop(gtkStatusbar, contextId);
	}
	
	/**
	 * Forces the removal of a message from a statusbar's stack.
	 * The exact context_id and message_id must be specified.
	 * Params:
	 * contextId =  a context identifier
	 * messageId =  a message identifier, as returned by gtk_statusbar_push()
	 */
	public void remove(uint contextId, uint messageId)
	{
		// void gtk_statusbar_remove (GtkStatusbar *statusbar,  guint context_id,  guint message_id);
		gtk_statusbar_remove(gtkStatusbar, contextId, messageId);
	}
	
	/**
	 * Sets whether the statusbar has a resize grip.
	 * TRUE by default.
	 * Params:
	 * setting =  TRUE to have a resize grip
	 */
	public void setHasResizeGrip(int setting)
	{
		// void gtk_statusbar_set_has_resize_grip (GtkStatusbar *statusbar,  gboolean setting);
		gtk_statusbar_set_has_resize_grip(gtkStatusbar, setting);
	}
	
	/**
	 * Returns whether the statusbar has a resize grip.
	 * Returns: TRUE if the statusbar has a resize grip.
	 */
	public int getHasResizeGrip()
	{
		// gboolean gtk_statusbar_get_has_resize_grip (GtkStatusbar *statusbar);
		return gtk_statusbar_get_has_resize_grip(gtkStatusbar);
	}
}
