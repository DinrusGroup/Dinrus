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

module gtkD.gtk.SpawnTests;

private import gtkD.glib.Spawn;
private import gtkD.gtk.Main;

private import gtkD.gtk.TextView;
private import gtkD.gtk.TextBuffer;
private import gtkD.gtk.TextIter;
private import gtkD.gtk.Box;
private import gtkD.gtk.VBox;
private import gtkD.gtk.ScrolledWindow;

private import gtkD.gtk.MainWindow;

private import gtkD.gtk.Button;
private import gtkD.gtk.Image;

version(Tango){
    import tango.text.Util;
    import tango.io.Stdout;
    void writefln( string frm, ... ){
        string frm2 = substitute( frm, "%s", "{}" );
        Stdout( Stdout.layout.convert( _arguments, _argptr, frm2 )).newline;
    }
}
else{
    import std.string;
    import std.io;
}
class SpawnWindow : MainWindow
{

	TextView viewInput;
	TextView viewOutput;
	TextView viewError;
        TextIter iterOut;
        TextIter iterError;

	this()
	{
		super("Spawn testing");
		setupWindow();
		setSizeRequest(400,400);
		showAll();
	}

	private void setupWindow()
	{
		Box main = new VBox(false, 2);

		viewInput = new TextView();
		viewOutput = new TextView();
		viewError = new TextView();

		main.packStart(new ScrolledWindow(viewInput), false, false, 2);
		Button button = new Button("exec", &execInput);
		main.packStart(button, false, false, 4);
		main.packStart(new ScrolledWindow(viewOutput), true, true, 2);
		main.packStart(new ScrolledWindow(viewError), false, false, 2);

		setBorderWidth(7);
		add(main);
	}

	private void execInput(Button button)
	{
        version(Tango){
          string[] args = split( viewInput.getBuffer().getText(), " " );
        }
        else{
		  string[] args = std.string.split(viewInput.getBuffer().getText());
        }
		exec(args);
	}

	private bool exec(string[] args)
	{
		foreach ( int i, string arg ; args)
		{
			writefln("[%s] >%s<", i, arg);
		}
		Spawn spawn = new Spawn(args[0]);
		//spawn.addChildWatch(&childEnded);
                //spawn.commandLineSync(&childEnded, &syncOutput, &syncError);
		if (args.length > 1 )
		{
			for( int i=1 ; i<args.length ; i++ )
			{
				writefln("SpawnTests.exec adding parameter [%s] %s",i,args[i]);
				spawn.addParm(args[i]);
			}
		}
		//spawn.addParm(null);
		return exec(spawn);
	}

        /*
	void childEnded(int process, int status)
	{
		writefln("process %s ended with status %s", process, status);
	}*/
        bool childEnded(Spawn spawn)
        {

                writefln("process %s ended with status %s", viewInput.getBuffer().getText(),spawn.getExitStatus());
                return true; //gotta check this.
        }

	private bool exec(Spawn spawn)
	{

		viewOutput.getBuffer().setText("");
		viewError.getBuffer().setText("");

		//int result = spawn.execAsyncWithPipes();

		//int outCount;
		//int errCount;

		//TextBuffer bufferOutput = viewOutput.getBuffer();
		TextBuffer bufferError = viewError.getBuffer();
		//TextIter iterOut = new TextIter();
		TextIter iterError = new TextIter();

                /* Apparently the following code is obsolete
                 * and should not compile. Delegates and commandLineSync should
                 * be used instead.
                 */
		/*while ( !spawn.endOfOutput() )
		{
			bufferOutput.getEndIter(iterOut);
			//viewOutput.getBuffer().insert(iterOut, spawn.readLine()~"\n");
                        viewOutput.getBuffer().insert(iterOut, spawn.getOutputString()~"\n");

		}

		while ( !spawn.endOfError() )
		{
			bufferError.getEndIter(iterError);
			//viewError.getBuffer().insert(iterError, spawn.readLineError()~"\n");
                        viewError.getBuffer().insert(iterError, spawn.getErrorString()~"\n");
		}*/

                int result = spawn.commandLineSync(&childEnded, &syncOutput, &syncError);

		bufferError.getEndIter(iterError);
		viewError.getBuffer().insert(iterError, spawn.getLastError()~"\n");

		writefln("exit loop");

		spawn.close();
		return true;
	}

        public bool syncOutput(string line)
        {
            TextIter iter = new TextIter();
            viewOutput.getBuffer().getEndIter(iter);
            viewOutput.getBuffer().insert(iter, line~"\n");
            return true;
        }

        public bool syncError(string line)
        {
            TextIter iter = new TextIter();
            viewError.getBuffer().getEndIter(iter);
            viewError.getBuffer().insert(iter, line~"\n");
            return true;
        }

	public void setInput(string[] args)
	{
		TextBuffer inBuffer = viewInput.getBuffer();
		string t;
		foreach ( int count, string arg; args)
		{
			if ( count > 0 ) t ~= " ";
			t ~= arg;
		}
		inBuffer.setText(t);
	}

	public void setInput(string arg)
	{
		viewInput.getBuffer().setText(arg);
	}


}

void main(string[] args)
{
	Main.init(args);

	SpawnWindow sw = new SpawnWindow();
	if ( args.length > 1 )
	{
		sw.setInput(args[1..args.length]);
	}
	else
	{
		sw.setInput("/bin/ls");
	}

	Main.run();
}
