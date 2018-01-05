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

module sourceView.SVTest;

version = Tango;

private import gtkD.gtk.MainWindow;
private import gtkD.gtk.Main;
private import gtkD.gtk.ScrolledWindow;
private import gtkD.gtk.Widget;

private import gtkD.glib.Str;

private import gtkD.gsv.SourceView;
private import gtkD.gsv.SourceBuffer;
private import gtkD.gsv.SourceLanguage;
private import gtkD.gsv.SourceLanguageManager;
private import gtkD.gsv.SourceBuffer;

version(Tango)
{
	private import tango.io.Stdout;
	private import tango.text.Util;
	private import tango.io.device.File;

    void writefln( string frm, ... ){
        string frm2 = substitute( frm, "%s", "{}" );
        Stdout( Stdout.layout.convert( _arguments, _argptr, frm2 )).newline;
    }
}
else
{
	private import std.stdio;
	private import std.file;
}

/**
 * Demos for SourceView.
 * TODO on gsv: override methods from TextView, TextBuffer, etc
 */

class HelloWorld : MainWindow
{

	SourceView sourceView;
	
	this()
	{
		super("GtkD SourceView");
		setBorderWidth(10);
		add(getSourceView());
		setDefaultSize(640,400);
		showAll();
	}
	
	private string getDemoText()
	{
		string text;

		version(Tango)
		{
			try
			{
				auto file = new File ("SVTest.d");
				text = new char[file.length];
				file.read(text);
			}
			catch (Exception) { }
		}
		else
		{
			try
			{
				text = cast(string)std.file.read("SVTest.d");
			}
			catch ( FileException fe ) { }
		}

		return text;
	}
	
	private Widget getSourceView()
	{
		sourceView = new SourceView();
		sourceView.setShowLineNumbers(true);
		
		sourceView.setInsertSpacesInsteadOfTabs(false);
		sourceView.setTabWidth(4);
		sourceView.setHighlightCurrentLine(true);
		
		SourceBuffer sb = sourceView.getBuffer();
		sb.setText(getDemoText());
		
		ScrolledWindow scWindow = new ScrolledWindow();
		scWindow.add(sourceView);

		
		SourceLanguageManager slm = new SourceLanguageManager();
		SourceLanguage dLang = slm.getLanguage("d");
		
		if ( dLang !is null )
		{
			writefln("Setting language to D");
			sb.setLanguage(dLang);
			sb.setHighlightSyntax(true);
		}
		
		//sourceView.modifyFont("Courier", 9);
		sourceView.setRightMarginPosition(72);
		sourceView.setShowRightMargin(true);
		sourceView.setAutoIndent(true);
		
		
		return scWindow;
	}
}

void main(string[] args)
{
	Main.init(null);
	new HelloWorld();
	Main.run();

}
