module gtkD.gtk.PopupMenu;

import gtkD.gtk.Main;
import gtkD.gtk.EventBox;
import gtkD.gtk.MainWindow;
import gtkD.gtk.Menu;
import gtkD.gtk.Label;
import gtkD.gtk.ImageMenuItem;
import gtkD.gtk.Widget;
import gtkD.gtk.AccelGroup;

class ExampleWindow : MainWindow
{
	Menu menu;

	this()
	{
		super("GtkD: Popup Menu");
		setDefaultSize(200, 200);

		auto eventBox = new EventBox();
		eventBox.add( new Label("Right click") );
		eventBox.addOnButtonPress(&onButtonPress);
		add(eventBox);

		menu = new Menu();
		menu.append( new ImageMenuItem(StockID.CUT, cast(AccelGroup)null) );
		menu.append( new ImageMenuItem(StockID.COPY, cast(AccelGroup)null) );
		menu.append( new ImageMenuItem(StockID.PASTE, cast(AccelGroup)null) );
		menu.append( new ImageMenuItem(StockID.DELETE, cast(AccelGroup)null) );
		menu.attachToWidget(eventBox, null);

		showAll();
	}

	public bool onButtonPress(GdkEventButton* event, Widget widget)
	{
		if(event.type == GdkEventType.BUTTON_PRESS && event.button == 3)
		{
			menu.showAll();
			menu.popup(event.button, event.time);

			return true;
		}

		return false;
	}
}

void main(string[] arg)
{
	Main.init(arg);

	new ExampleWindow();

	Main.run();
}
