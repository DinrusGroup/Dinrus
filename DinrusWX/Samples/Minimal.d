//-----------------------------------------------------------------------------
// wxD/Samples - Minimal.d
// based on
// wx.NET/Samples - Minimal.cs
//
// A wx.NET version of the wxWidgets "minimal" sample.
//
// Written by Jason Perkins (jason@379.com)
// (C) 2003 by 379, Inc.
// Licensed under the wxWidgets license, see LICENSE.txt for details.
//
// $Id: Minimal.d,v 1.11 2008/04/07 22:12:49 afb Exp $
//-----------------------------------------------------------------------------

import wx.wx;

	public class MyFrame : Frame
	{
		enum Cmd
		{
			About = MenuIDs.wxID_ABOUT,
			Quit = MenuIDs.wxID_EXIT,
			Dialog = MenuIDs.wxID_HIGHEST + 1
		}

		//---------------------------------------------------------------------

		public this(string title, Point pos, Size size)
		{
			super(title, pos, size);
			// Set the window icon

			version (__WXMAC_XCODE__)
			icon = new Icon("Minimal.app/Contents/Resources/mondrian.png");
			else
			icon = new Icon("./data/mondrian.png");

			// Set up a menu

			Menu fileMenu = new Menu();
			fileMenu.Append(Cmd.Dialog, "&Паказать диалог\tAlt-D", "Показать тестовый диалог");
			fileMenu.Append(Cmd.Quit, "Вы&ход\tAlt-X", "Выйти из программы");

			Menu helpMenu = new Menu();
			helpMenu.Append(Cmd.About, "&О...\tF1", "Показать диалоговое окно \"О...\"");

			MenuBar menuBar = new MenuBar();
			menuBar.Append(fileMenu, "&Файл");
			menuBar.Append(helpMenu, "&Справка");

			this.menuBar = menuBar;

			// Set up a status bar

			CreateStatusBar(2);
			StatusText = "Добро пожаловать в wxWidgets!";

			// Set up the event table

			EVT_MENU(Cmd.Quit,    &OnQuit);
			EVT_MENU(Cmd.Dialog,  &OnDialog);
			EVT_MENU(Cmd.About,   &OnAbout);
		}

		//---------------------------------------------------------------------

		public void OnQuit(Object sender, Event e)
		{
			Close();
		}

		//---------------------------------------------------------------------

		public void OnDialog(Object sender, Event e)
		{
            Dialog dialog = new Dialog( this, -1, "Тестировать диалог", Point(50,50), Size(450,340) );
            BoxSizer main_sizer = new BoxSizer( Orientation.wxVERTICAL );

            StaticBoxSizer top_sizer = new StaticBoxSizer( new StaticBox( dialog, -1, "Bitmaps" ), Orientation.wxHORIZONTAL );
            main_sizer.Add( top_sizer, 0, Direction.wxALL, 5 );

            BitmapButton bb = new BitmapButton( dialog, -1, new Bitmap("./data/mondrian.png") );
            top_sizer.Add( bb, 0, Direction.wxALL, 10 );

            StaticBitmap sb = new StaticBitmap( dialog, -1, new Bitmap("./data/mondrian.png") );
            top_sizer.Add( sb, 0, Direction.wxALL, 10 );

            Button button = new Button( dialog, 5100, "OK" );
            main_sizer.Add( button, 0, Direction.wxALL|Alignment.wxALIGN_CENTER, 5 );

            dialog.SetSizer( main_sizer, true );
            main_sizer.Fit( dialog );
            main_sizer.SetSizeHints( dialog );

            dialog.CentreOnParent();
            dialog.ShowModal();
		}

		//---------------------------------------------------------------------

		public void OnAbout(Object sender, Event e)
		{
			string msg = "Это диалоговое окно \"О...\" минимальной программы.\nДобро пожаловать в " ~ wxVERSION_STRING;
			MessageBox(this, msg, "О Минимале", Dialog.wxOK | Dialog.wxICON_INFORMATION);
		}

		//---------------------------------------------------------------------
	}



	public class Minimal : App
	{
		//---------------------------------------------------------------------

		public override bool OnInit()
		{
			MyFrame frame = new MyFrame("Минимальное приложение  wxWidgets", Point(50,50), Size(450,340));
			frame.Show(true);

			return true;
		}

		//---------------------------------------------------------------------

		static void Main()
		{
			Minimal app = new Minimal();
			app.Run();
		}

		//---------------------------------------------------------------------
	}

int main()
{
	Minimal.Main();
	return 0;
}
