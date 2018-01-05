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

module gtkD.gtk.OtherTests;

private import gtkD.gtk.AboutDialog;
private import gtkD.gtk.Dialog;
private import gtkD.gtk.Widget;
private import gtkD.gtk.Window;
private import gtkD.gtk.Label;
private import gtkD.gtk.Button;
private import gtkD.gtk.VBox;
private import gtkD.gtk.Main;
private import gtkD.gtk.Image;

private import gtkD.gtk.Timeout;
private import gtkD.gdk.Event;

version(Tango){
    import tango.text.Util;
    import tango.io.Stdout;
    void writefln( string frm, ... ){
        string frm2 = substitute( frm, "%s", "{}" );
        Stdout( Stdout.layout.convert( _arguments, _argptr, frm2 )).newline;
    }
}
else{
    import std.io;
}

public class OtherTests : Window
{

	Label byeLabel;
	Timeout timeout;

	this()
	{
		super("GtkD");
		setDecorated(true);
		VBox box = new VBox(false, 2);
		box.add(new Label("Привет, Мир"));
		Button button = new Button("О программе");
		button.addOnClicked(&onClicked);
		button.addOnClicked(&popupAbout);
		button.addOnClicked(delegate void(Button b){
			writefln("\nбуквально нажато");
		});

		button.addOnPressed(&mousePressed);
		//addOnButtonPress(&mousePressed);

		box.add(button);
		byeLabel = new Label("Пока-пока, Мир");
		box.add(byeLabel);
		add(box);
		setBorderWidth(10);
		move(0,400);
		showAll();

		addOnDelete(&onDeleteEvent);

		timeout = new Timeout(1000, &changeLabel);
	}

	void mousePressed(Button widget)
	{
		writefln("mousePressed");
	}

	bool changeLabel()
	{
		switch ( byeLabel.getText() )
		{
			case "Пока-пока, Мир": byeLabel.setText("всё ещё тут"); break;
			case "всё ещё тут": byeLabel.setText("закрой окно"); break;
			case "закрой окно": byeLabel.setText("для завершения"); break;
			default : byeLabel.setText("Пока-пока, Мир"); break;
		}
		return true;
	}

	void onClicked(Button button)
	{
		writefln("\nOn click from Hello World %s", button);
	}

	void popupAbout(Button button)
	{
		with (new AboutDialog())
		{

			string[] names;
			names ~= "Antonio Monteiro (binding/wrapping/proxying/decorating for D)";
			names ~= "www.gtk.org (base C library)";
			setAuthors(names);
			setDocumenters(names);
			setArtists(names);
			setLicense("Лицензия LGPL");
			setWebsite("http://lisdev.com");
			addOnResponse(&onDialogResponse);
			showAll();
		}
	}

	void onDialogResponse(int response, Dialog dlg)
	{
		if(response == GtkResponseType.GTK_RESPONSE_CANCEL)
			dlg.destroy();
	}

	bool onDeleteEvent(Event event, Widget widget)
	{
		destroy();
		writefln("Exit by request from HelloWorld");
		Main.exit(0);
		return false;
	}

	string toString()
	{
		return "I Am HelloWorld";
	}

}

void main(string[] args)
{
	Main.init(args);
	new OtherTests();
	Main.run();
}

