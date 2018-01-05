﻿module gtkD.gtk.DrawRect;

import gtkD.gtk.Main;
import gtkD.gtk.MainWindow;
import gtkD.gtk.Widget;
import gtkD.gdk.GC;
import gtkD.gdk.Drawable;
import gtkD.gdk.Color;

void main (string[] args)
{
	Main.init(args);
	MainWindow window = new MainWindow("Gtkd пример рисования прямоугольника");
	
	window.addOnHide(
		delegate void (Widget whatever)
		{
			Main.exit(0);
		}
	);

	window.addOnExpose(
		delegate bool (GdkEventExpose * whatever_II, Widget widget)
		{
			Drawable da = widget.getWindow();
			da.drawRectangle(	gcFgColor(da, 0, 255, 255), true,
								0, 0, window.getHeight(), window.getWidth()
			);
			return true;
		}
	);

	window.showAll();
	Main.run();
}

GC gcFgColor (Drawable da, int r, int g, int b)
{
	if (r<0) r=0;	if (r>255) r=255;
	if (g<0) r=0;	if (g>255) g=255;
	if (b<0) r=0;	if (b>255) b=255;

	GC rt = new GC(da);
	rt.setRgbFgColor( new Color(cast(ubyte)r, cast(ubyte)g, cast(ubyte)b) );

	return rt;
}
